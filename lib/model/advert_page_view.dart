import 'category.dart';
import 'city.dart';
import 'phonecode.dart';

class AdvertPageView {
  final String id;
  final String categoryName;
  final String name;
  final String description;
  final String cityName;
  final String address;
  final String phoneCode;
  final String phone;
  final DateTime createdAt;

  factory AdvertPageView.fromJson(List<Category> categories, List<City> cities,
      List<PhoneCode> phoneCodes, Map<String, dynamic> json) {
    return AdvertPageView(
        id: json['id'],
        categoryName: json['category']['name'],
        name: json['name'],
        description: json['description'],
        cityName: json['city']['name'],
        address: json['address'],
        phoneCode: json['phonecode']['code'],
        phone: json['phone'],
        createdAt: DateTime.parse(json['created_at']));
  }

  AdvertPageView({
    required this.id,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.cityName,
    required this.address,
    required this.phoneCode,
    required this.phone,
    required this.createdAt,
  });
}
