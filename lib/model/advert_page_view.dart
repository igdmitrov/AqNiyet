class AdvertPageView {
  final String id;
  final String categoryId;
  final String categoryName;
  final String name;
  final String description;
  final String cityId;
  final String cityName;
  final String address;
  final bool enabled;
  final String createdBy;
  final DateTime createdAt;

  factory AdvertPageView.fromJson(Map<String, dynamic> json) {
    return AdvertPageView(
        id: json['id'],
        categoryId: json['category_id'],
        categoryName: json['category']['name'],
        name: json['name'],
        description: json['description'],
        cityId: json['city_id'],
        cityName: json['city']['name'],
        address: json['address'],
        enabled: json['enabled'],
        createdBy: json['created_by'],
        createdAt: DateTime.parse(json['created_at']));
  }

  AdvertPageView({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.cityId,
    required this.cityName,
    required this.address,
    required this.enabled,
    required this.createdAt,
    required this.createdBy,
  });
}
