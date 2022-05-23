class City {
  final String id;
  final String name;
  final int num;

  City({required this.id, required this.name, required this.num});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      num: json['num'],
    );
  }
}
