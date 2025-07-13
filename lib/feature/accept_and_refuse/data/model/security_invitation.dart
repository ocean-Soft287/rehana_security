class SecurityInvitation {
  final String type;
  final int invitationId;
  final String status;
  final bool isAccepted;

  SecurityInvitation({
    required this.type,
    required this.invitationId,
    required this.status,
    required this.isAccepted,
  });

  factory SecurityInvitation.fromJson(Map<String, dynamic> json) {
    return SecurityInvitation(
      type: json['Type'] as String? ?? '',
      invitationId: json['InvitationId'] as int? ?? 0,
      status: json['Status'] as String? ?? '',
      isAccepted: json['IsAccepted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'Type': type,
    'InvitationId': invitationId,
    'Status': status,
    'IsAccepted': isAccepted,
  };
}
