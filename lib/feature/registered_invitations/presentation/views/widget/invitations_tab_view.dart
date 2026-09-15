import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';
import '../../../../../core/widget/context_show.dart';
import '../../../../../core/widget/loading_button.dart';
import '../../../data/model/registered_invitation_model.dart';
import '../../manger/registered_invitations_cubit.dart';
import 'invitation_card.dart';
import 'invitations_filter_bar.dart';

class InvitationsTabView extends StatefulWidget {
  const InvitationsTabView({super.key, required this.status});

  final InvitationStatus status;

  @override
  State<InvitationsTabView> createState() => _InvitationsTabViewState();
}

class _InvitationsTabViewState extends State<InvitationsTabView>
    with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RegisteredInvitationsCubit>().loadInitial(widget.status);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 250) {
      context.read<RegisteredInvitationsCubit>().loadNextPage(widget.status);
    }
  }

  RegisteredInvitationsCubit get _cubit =>
      context.read<RegisteredInvitationsCubit>();

  Future<void> _pickDate({required bool isFrom}) async {
    final tab = _cubit.tabOf(widget.status);
    final initial = (isFrom ? tab.fromDate : tab.toDate) ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder:
          (context, child) =>
              Directionality(textDirection: TextDirection.rtl, child: child!),
    );

    if (picked == null || !mounted) return;

    var from = isFrom ? picked : tab.fromDate;
    var to = isFrom ? tab.toDate : picked;

    // لو المستخدم اختار مدى غير منطقى نصحح الطرف الآخر
    if (from != null && to != null && from.isAfter(to)) {
      if (isFrom) {
        to = from;
      } else {
        from = to;
      }
    }

    await _cubit.applyDateFilter(widget.status, fromDate: from, toDate: to);
  }

  Future<void> _confirmEnd(RegisteredInvitationModel invitation) async {
    final confirmed = await showConfirmDialogGlobal(
      title: 'إنهاء الدعوة',
      message:
          'هل أنت متأكد من إنهاء دعوة '
          '${invitation.visitorName.trim().isEmpty ? 'الزائر' : invitation.visitorName}'
          ' لفيلا ${invitation.villaNumber}؟',
      confirmText: 'إنهاء',
    );

    if (!confirmed || !mounted) return;

    await _cubit.endInvitation(invitation);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<RegisteredInvitationsCubit, RegisteredInvitationsState>(
      builder: (context, state) {
        final tab = _cubit.tabOf(widget.status);
        final isActiveTab = widget.status == InvitationStatus.active;

        return Column(
          children: [
            InvitationsFilterBar(
              searchController: _searchController,
              onSearchChanged: (value) {
                setState(() {}); // لتحديث زر مسح البحث
                _cubit.searchByMemberName(widget.status, value);
              },
              fromDate: tab.fromDate,
              toDate: tab.toDate,
              onPickFromDate: () => _pickDate(isFrom: true),
              onPickToDate: () => _pickDate(isFrom: false),
              onClearFilters: () {
                _searchController.clear();
                setState(() {});
                _cubit.clearFilters(widget.status);
              },
              hasFilters: tab.hasFilters,
              totalItems: tab.totalItems,
            ),

            Expanded(child: _buildBody(tab, state, isActiveTab)),
          ],
        );
      },
    );
  }

  Widget _buildBody(
    InvitationsTabState tab,
    RegisteredInvitationsState state,
    bool isActiveTab,
  ) {
    if (tab.isLoading) {
      return const Center(child: LoadingButton());
    }

    if (tab.errorMessage != null && tab.items.isEmpty) {
      return _ErrorView(
        message: tab.errorMessage!,
        onRetry: () => _cubit.retry(widget.status),
      );
    }

    if (tab.items.isEmpty) {
      return RefreshIndicator(
        color: AppColors.bIcon,
        onRefresh: () => _cubit.refresh(widget.status),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 80.h),
            _EmptyView(
              message:
                  tab.hasFilters
                      ? 'لا توجد دعاوى مطابقة لبحثك'
                      : isActiveTab
                      ? 'لا توجد دعاوى نشطة حاليا'
                      : 'لا توجد دعاوى منتهية',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.bIcon,
      onRefresh: () => _cubit.refresh(widget.status),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
        itemCount: tab.items.length + (tab.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= tab.items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: LoadingButton()),
            );
          }

          final invitation = tab.items[index];

          return InvitationCard(
            invitation: invitation,
            isEnding: state.endingInvitationId == invitation.id,
            isEndDisabled:
                state.endingInvitationId != null &&
                state.endingInvitationId != invitation.id,
            onEnd: isActiveTab ? () => _confirmEnd(invitation) : null,
          );
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.inbox_outlined,
          size: 64.r,
          color: AppColors.circlecolor.withValues(alpha: 0.5),
        ),
        SizedBox(height: 12.h),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: Font.alex,
            color: AppColors.circlecolor,
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56.r, color: AppColors.red),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: Font.alex,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 16.h),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.bIcon,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 18.r, color: AppColors.white),
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: Font.alex,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
