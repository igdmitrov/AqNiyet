import 'base_model.dart';

class Advert implements BaseModel {
  @override
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String countryId;
  final String cityId;
  final String address;
  final String phone;
  final bool enabled;
  final String createdBy;

  factory Advert.fromJson(Map<String, dynamic> json) {
    return Advert(
        id: json['id'],
        categoryId: json['category_id'],
        name: json['name'],
        description: json['description'],
        countryId: json['country_id'],
        cityId: json['city_id'],
        address: json['address'],
        phone: json['phone'],
        enabled: json['enabled'],
        createdBy: json['created_by']);
  }

  Advert({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    this.countryId = 'kz',
    required this.cityId,
    required this.address,
    required this.phone,
    required this.enabled,
    required this.createdBy,
  });

  Map toMap() {
    return {
      'category_id': categoryId,
      'name': name,
      'description': description,
      'country_id': countryId,
      'city_id': cityId,
      'address': address,
      'phone': phone,
      'enabled': enabled,
      'created_by': createdBy,
    };
  }

  @override
  String value() => name;
}
