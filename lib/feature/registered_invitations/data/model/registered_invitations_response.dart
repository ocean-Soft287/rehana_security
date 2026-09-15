import 'registered_invitation_model.dart';

/// الريسبونس المقسم لصفحات الراجع من endpoint الدعاوى المسجلة
class RegisteredInvitationsResponse {
  final List<RegisteredInvitationModel> items;
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  RegisteredInvitationsResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  factory RegisteredInvitationsResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return RegisteredInvitationsResponse(
      items:
          rawItems is List
              ? rawItems
                  .whereType<Map<String, dynamic>>()
                  .map(RegisteredInvitationModel.fromJson)
                  .toList()
              : <RegisteredInvitationModel>[],
      page: _parseInt(json['page'], fallback: 1),
      pageSize: _parseInt(json['pageSize'], fallback: 10),
      totalItems: _parseInt(json['totalItems']),
      totalPages: _parseInt(json['totalPages']),
    );
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  bool get hasNextPage => page < totalPages;
}
