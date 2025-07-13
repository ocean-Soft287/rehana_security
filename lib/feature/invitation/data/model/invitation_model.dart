class Invitation {
  final String invitationId;
  final String qrCode;
  final String status;
  final bool? isAccepted;

  Invitation({
    required this.invitationId,
    required this.qrCode,
    required this.status,
    this.isAccepted,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      invitationId: json['invitationId'] as String,
      qrCode: json['qrCode'] as String,
      status: json['status'] as String,
      isAccepted: json['isAccepted'] as bool?,
    );
  }
}