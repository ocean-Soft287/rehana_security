/// حالة الدعوة كما ترجع من الـ API
enum InvitationStatus {
  active('Active'),
  expired('Expired');

  const InvitationStatus(this.apiValue);

  final String apiValue;

  String get arabicLabel =>
      this == InvitationStatus.active ? 'نشطة' : 'منتهية';
}

class RegisteredInvitationModel {
  final String id;
  final String villaNumber;
  final String visitorName;
  final String carPlateNumber;
  final DateTime? visitTime;
  final String notes;
  final String memberName;
  final DateTime? createdAt;
  final String status;
  final DateTime? endedAt;

  RegisteredInvitationModel({
    required this.id,
    required this.villaNumber,
    required this.visitorName,
    required this.carPlateNumber,
    required this.visitTime,
    required this.notes,
    required this.memberName,
    required this.createdAt,
    required this.status,
    required this.endedAt,
  });

  factory RegisteredInvitationModel.fromJson(Map<String, dynamic> json) {
    return RegisteredInvitationModel(
      id: json['id']?.toString() ?? '',
      villaNumber: json['villaNumber']?.toString() ?? '',
      visitorName: json['visitorName']?.toString() ?? '',
      carPlateNumber: json['carPlateNumber']?.toString() ?? '',
      visitTime: _parseDate(json['visitTime']),
      notes: json['notes']?.toString() ?? '',
      memberName: json['memberName']?.toString() ?? '',
      createdAt: _parseDate(json['createdAt']),
      status: json['status']?.toString() ?? '',
      endedAt: _parseDate(json['endedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  bool get isActive =>
      status.toLowerCase() == InvitationStatus.active.apiValue.toLowerCase();

  /// نسخة من الدعوة بعد إنهائها — تستخدم لنقلها من التاب النشط للمنتهى
  RegisteredInvitationModel asEnded() {
    return RegisteredInvitationModel(
      id: id,
      villaNumber: villaNumber,
      visitorName: visitorName,
      carPlateNumber: carPlateNumber,
      visitTime: visitTime,
      notes: notes,
      memberName: memberName,
      createdAt: createdAt,
      status: InvitationStatus.expired.apiValue,
      endedAt: DateTime.now(),
    );
  }
}
