class AdvertMenuItem {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final String createdBy;

  factory AdvertMenuItem.fromJson(Map<String, dynamic> json) {
    return AdvertMenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['created_by'],
    );
  }

  AdvertMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.createdBy,
  });
}
