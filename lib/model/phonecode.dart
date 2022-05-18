class PhoneCode {
  final String id;
  final String code;
  final String countryName;

  PhoneCode({required this.id, required this.code, required this.countryName});

  factory PhoneCode.fromJson(Map<String, dynamic> json) {
    return PhoneCode(
      id: json['id'],
      code: json['code'],
      countryName: json['countryname'],
    );
  }

  String getName() => '$code $countryName';
}
