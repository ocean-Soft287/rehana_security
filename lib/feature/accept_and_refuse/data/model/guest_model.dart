class GuestInvitationModel {
  final String id;
  final String type;
  final int securityGuardId;
  final String guestName;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String status;
  final String picture;

  GuestInvitationModel({
    required this.id,
    required this.type,
    required this.securityGuardId,
    required this.guestName,
    required this.dateFrom,
    required this.dateTo,
    required this.status,
    required this.picture,
  });

  factory GuestInvitationModel.fromJson(Map<String, dynamic> json) {
    return GuestInvitationModel(
      id: json['Id'] ?? '',
      type: json['Type'] ?? 'OneTime',
      securityGuardId: json['SecurityGuardId'] ?? 0,
      guestName: json['GuestName'] ?? '',
      dateFrom: json['DateFrom'] != null
          ? DateTime.tryParse(json['DateFrom']) ?? DateTime.now()
          : DateTime.now(),
      dateTo: json['DateTo'] != null
          ? DateTime.tryParse(json['DateTo']) ?? DateTime.now()
          : DateTime.now(),
      status: json['Status'] ?? 'Unknown',
      picture: json['Picture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Type': type,
      'SecurityGuardId': securityGuardId,
      'GuestName': guestName,
      'DateFrom': dateFrom.toIso8601String(),
      'DateTo': dateTo.toIso8601String(),
      'Status': status,
      'Picture': picture,
    };
  }
}
