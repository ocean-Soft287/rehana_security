class VillaModel {
  final String villaNumber;
  final String memberName;

  VillaModel({required this.villaNumber, required this.memberName});

  factory VillaModel.fromJson(Map<String, dynamic> json) {
    return VillaModel(
      villaNumber: json['villaNumber'] as String? ?? '',
      memberName: json['memberName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'villaNumber': villaNumber,
    'memberName': memberName,
  };

  /// ما يظهر داخل ال dropdown : رقم الفيلا + اسم المالك
  String get displayName =>
      memberName.isEmpty ? villaNumber : '$villaNumber - $memberName';
}
