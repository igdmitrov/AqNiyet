import 'base_model.dart';

class City implements BaseModel {
  @override
  final String id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  String value() => name;
}
