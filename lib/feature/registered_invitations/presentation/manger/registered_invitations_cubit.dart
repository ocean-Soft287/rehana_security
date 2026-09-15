import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../data/model/registered_invitation_model.dart';
import '../../data/repo/registered_invitations_repo.dart';

part 'registered_invitations_state.dart';

class RegisteredInvitationsCubit extends Cubit<RegisteredInvitationsState> {
  RegisteredInvitationsCubit(this.registeredInvitationsRepo)
    : super(const RegisteredInvitationsState());

  final RegisteredInvitationsRepo registeredInvitationsRepo;

  static const int pageSize = 10;

  Timer? _searchDebounce;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  InvitationsTabState tabOf(InvitationStatus status) =>
      status == InvitationStatus.active ? state.active : state.expired;

  void _emitTab(InvitationStatus status, InvitationsTabState tab) {
    emit(
      status == InvitationStatus.active
          ? state.copyWith(active: tab)
          : state.copyWith(expired: tab),
    );
  }

  /// أول تحميل للتاب — يتجاهل الطلب لو فيه بيانات محملة بالفعل
  Future<void> loadInitial(InvitationStatus status) async {
    final tab = tabOf(status);
    if (tab.items.isNotEmpty || tab.isLoading) return;
    await _fetchFirstPage(status);
  }

  Future<void> refresh(InvitationStatus status) =>
      _fetchFirstPage(status, isRefreshing: true);

  Future<void> retry(InvitationStatus status) => _fetchFirstPage(status);

  /// بحث بالاسم مع debounce حتى لا نرسل ريكوست مع كل حرف
  void searchByMemberName(InvitationStatus status, String memberName) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final trimmed = memberName.trim();
      final tab = tabOf(status);

      if ((tab.memberName ?? '') == trimmed) return;

      _emitTab(
        status,
        tab.copyWith(memberName: trimmed.isEmpty ? null : trimmed),
      );
      _fetchFirstPage(status);
    });
  }

  Future<void> applyDateFilter(
    InvitationStatus status, {
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final tab = tabOf(status);
    _emitTab(status, tab.copyWith(fromDate: fromDate, toDate: toDate));
    await _fetchFirstPage(status);
  }

  Future<void> clearFilters(InvitationStatus status) async {
    _searchDebounce?.cancel();
    _emitTab(status, tabOf(status).copyWith(clearFilters: true));
    await _fetchFirstPage(status);
  }

  Future<void> _fetchFirstPage(
    InvitationStatus status, {
    bool isRefreshing = false,
  }) async {
    final tab = tabOf(status);

    _emitTab(
      status,
      tab.copyWith(
        isLoading: !isRefreshing,
        isRefreshing: isRefreshing,
        clearError: true,
      ),
    );

    final result = await registeredInvitationsRepo.getInvitations(
      status: status,
      memberName: tab.memberName,
      fromDate: tab.fromDate,
      toDate: tab.toDate,
      page: 1,
      pageSize: pageSize,
    );

    // الفلاتر ممكن تكون اتغيرت أثناء الريكوست — نقرأ آخر نسخة من التاب
    final current = tabOf(status);

    result.fold(
      (failure) => _emitTab(
        status,
        current.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: failure.message,
        ),
      ),
      (response) => _emitTab(
        status,
        current.copyWith(
          items: response.items,
          isLoading: false,
          isRefreshing: false,
          clearError: true,
          page: response.page,
          totalItems: response.totalItems,
          totalPages: response.totalPages,
        ),
      ),
    );
  }

  Future<void> loadNextPage(InvitationStatus status) async {
    final tab = tabOf(status);

    if (tab.isLoading || tab.isLoadingMore || !tab.hasNextPage) return;

    _emitTab(status, tab.copyWith(isLoadingMore: true, clearError: true));

    final nextPage = tab.page + 1;

    final result = await registeredInvitationsRepo.getInvitations(
      status: status,
      memberName: tab.memberName,
      fromDate: tab.fromDate,
      toDate: tab.toDate,
      page: nextPage,
      pageSize: pageSize,
    );

    final current = tabOf(status);

    result.fold(
      (failure) => _emitTab(
        status,
        current.copyWith(isLoadingMore: false, errorMessage: failure.message),
      ),
      (response) {
        // نتجنب تكرار العناصر لو الصفحة رجعت بيانات متداخلة
        final existingIds = current.items.map((e) => e.id).toSet();
        final newItems =
            response.items
                .where((item) => !existingIds.contains(item.id))
                .toList();

        _emitTab(
          status,
          current.copyWith(
            items: [...current.items, ...newItems],
            isLoadingMore: false,
            page: response.page,
            totalItems: response.totalItems,
            totalPages: response.totalPages,
          ),
        );
      },
    );
  }

  /// إنهاء دعوة نشطة: تتشال من تاب النشطة وتتحط فى تاب المنتهية
  Future<void> endInvitation(RegisteredInvitationModel invitation) async {
    if (state.endingInvitationId != null) return;

    emit(
      state.copyWith(
        endingInvitationId: invitation.id,
        clearEndMessages: true,
      ),
    );

    final result = await registeredInvitationsRepo.endInvitation(invitation.id);

    result.fold(
      (failure) => emit(
        state.copyWith(clearEndingId: true, endErrorMessage: failure.message),
      ),
      (message) {
        final active = state.active;
        final expired = state.expired;

        final remaining =
            active.items.where((item) => item.id != invitation.id).toList();

        final removedCount = active.items.length - remaining.length;

        emit(
          state.copyWith(
            active: active.copyWith(
              items: remaining,
              totalItems:
                  (active.totalItems - removedCount)
                      .clamp(0, active.totalItems)
                      .toInt(),
            ),
            // نضيفها لتاب المنتهية فقط لو التاب اتحمل قبل كده وبدون فلاتر،
            // غير كده الريفرش هيجيبها من السيرفر بالترتيب الصحيح
            expired:
                expired.items.isEmpty || expired.hasFilters
                    ? expired
                    : expired.copyWith(
                      items: [invitation.asEnded(), ...expired.items],
                      totalItems: expired.totalItems + 1,
                    ),
            clearEndingId: true,
            endSuccessMessage: message,
          ),
        );

        // نعيد تحميل تاب المنتهية من السيرفر لضمان تطابق البيانات والترقيم
        if (expired.items.isNotEmpty || expired.hasFilters) {
          refresh(InvitationStatus.expired);
        }
      },
    );
  }

  /// تستدعى بعد عرض رسالة النجاح/الخطأ حتى لا تتكرر مع كل rebuild
  void consumeEndMessages() {
    if (state.endSuccessMessage == null && state.endErrorMessage == null) {
      return;
    }
    emit(state.copyWith(clearEndMessages: true));
  }
}
