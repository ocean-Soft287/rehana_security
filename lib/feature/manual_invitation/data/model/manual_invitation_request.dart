class ManualInvitationRequest {
  final String villaNumber;
  final String? visitorName;
  final String carPlateNumber;
  final DateTime visitTime;
  final String? notes;

  ManualInvitationRequest({
    required this.villaNumber,
    this.visitorName,
    required this.carPlateNumber,
    required this.visitTime,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'villaNumber': villaNumber,
    'visitorName': visitorName ?? '',
    'carPlateNumber': carPlateNumber,
    'visitTime': visitTime.toUtc().toIso8601String(),
    'notes': notes ?? '',
  };
}
