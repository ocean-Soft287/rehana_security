part of 'registered_invitations_cubit.dart';

/// حالة تاب واحد (نشطة أو منتهية)
class InvitationsTabState {
  final List<RegisteredInvitationModel> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;
  final int page;
  final int totalItems;
  final int totalPages;

  /// الفلاتر المطبقة حاليا على هذا التاب
  final String? memberName;
  final DateTime? fromDate;
  final DateTime? toDate;

  const InvitationsTabState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.page = 1,
    this.totalItems = 0,
    this.totalPages = 0,
    this.memberName,
    this.fromDate,
    this.toDate,
  });

  bool get hasNextPage => page < totalPages;

  bool get hasFilters =>
      (memberName != null && memberName!.isNotEmpty) ||
      fromDate != null ||
      toDate != null;

  bool get isEmpty => !isLoading && errorMessage == null && items.isEmpty;

  InvitationsTabState copyWith({
    List<RegisteredInvitationModel>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    int? page,
    int? totalItems,
    int? totalPages,
    String? memberName,
    DateTime? fromDate,
    DateTime? toDate,
    bool clearFilters = false,
  }) {
    return InvitationsTabState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      page: page ?? this.page,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      memberName: clearFilters ? null : (memberName ?? this.memberName),
      fromDate: clearFilters ? null : (fromDate ?? this.fromDate),
      toDate: clearFilters ? null : (toDate ?? this.toDate),
    );
  }
}

class RegisteredInvitationsState {
  final InvitationsTabState active;
  final InvitationsTabState expired;

  /// id الدعوة الجارى إنهاؤها حاليا (لإظهار اللودر على الكارت الصحيح)
  final String? endingInvitationId;

  /// رسالة نجاح/خطأ إنهاء الدعوة — تستهلك مرة واحدة فى الـ listener
  final String? endSuccessMessage;
  final String? endErrorMessage;

  const RegisteredInvitationsState({
    this.active = const InvitationsTabState(),
    this.expired = const InvitationsTabState(),
    this.endingInvitationId,
    this.endSuccessMessage,
    this.endErrorMessage,
  });

  RegisteredInvitationsState copyWith({
    InvitationsTabState? active,
    InvitationsTabState? expired,
    String? endingInvitationId,
    bool clearEndingId = false,
    String? endSuccessMessage,
    String? endErrorMessage,
    bool clearEndMessages = false,
  }) {
    return RegisteredInvitationsState(
      active: active ?? this.active,
      expired: expired ?? this.expired,
      endingInvitationId:
          clearEndingId ? null : (endingInvitationId ?? this.endingInvitationId),
      endSuccessMessage: clearEndMessages ? null : endSuccessMessage,
      endErrorMessage: clearEndMessages ? null : endErrorMessage,
    );
  }
}
