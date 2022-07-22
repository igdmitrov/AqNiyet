import 'base_model.dart';

class Message implements BaseModel {
  @override
  final String id;
  final String roomId;
  final String content;
  final String userFrom;
  final String userTo;
  final DateTime createdAt;

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        roomId = json['room_id'],
        content = json['content'],
        userFrom = json['user_from'],
        userTo = json['user_to'],
        createdAt = DateTime.parse(json['created_at']);

  Message({
    required this.id,
    required this.roomId,
    required this.content,
    required this.userFrom,
    required this.userTo,
    required this.createdAt,
  });

  Map toMap() {
    return {
      'room_id': roomId,
      'content': content,
      'user_from': userFrom,
      'user_to': userTo,
    };
  }

  @override
  String value() => content;

  bool isMine(String userId) => userFrom == userId;
}
