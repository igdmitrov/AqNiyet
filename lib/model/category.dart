class Category {
  final String id;
  final String name;
  final int num;

  Category({required this.id, required this.name, required this.num});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      num: json['num'],
    );
  }
}
