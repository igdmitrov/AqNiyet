class AdvertMenuItem {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  factory AdvertMenuItem.fromJson(Map<String, dynamic> json) {
    return AdvertMenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  AdvertMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });
}
