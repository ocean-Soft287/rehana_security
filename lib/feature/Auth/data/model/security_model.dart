class SecurityUser {
  final String email;
  final String userName;
  final String phoneNumber;
  final String? pictureUrl;
  final String gateNumber;
  final String token;

  SecurityUser({
    required this.email,
    required this.userName,
    required this.phoneNumber,
    this.pictureUrl,
    required this.gateNumber,
    required this.token,
  });

  factory SecurityUser.fromJson(Map<String, dynamic> json) {
    return SecurityUser(
      email: json['email'] as String,
      userName: json['userName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      pictureUrl: json['pictureUrl'] as String?,
      gateNumber: json['gateNumber'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'pictureUrl': pictureUrl,
      'gateNumber': gateNumber,
      'token': token,
    };
  }
}