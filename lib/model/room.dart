import 'base_model.dart';

class Room implements BaseModel {
  @override
  final String id;
  final String advertName;
  final String advertId;
  final String userFrom;
  final String userTo;
  final DateTime createdAt;

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
        id: json['id'],
        advertName: json['advert_name'],
        advertId: json['advert_id'],
        userFrom: json['user_from'],
        userTo: json['user_to'],
        createdAt: DateTime.parse(json['created_at']));
  }

  Room({
    required this.id,
    required this.advertName,
    required this.advertId,
    required this.userFrom,
    required this.userTo,
    required this.createdAt,
  });

  Map toMap() {
    return {
      'advert_name': advertName,
      'advert_id': advertId,
      'user_from': userFrom,
      'user_to': userTo,
    };
  }

  @override
  String value() => advertName;

  bool isSaved() => id.isNotEmpty;

  bool isNew() => id.isEmpty;
}
