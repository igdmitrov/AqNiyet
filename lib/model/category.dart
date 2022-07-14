import 'package:aqniyet/model/base_model.dart';

class Category implements BaseModel {
  @override
  final String id;

  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String value() {
    return name;
  }
}
