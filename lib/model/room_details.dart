class RoomDetails {
  final String roomId;
  final String messageId;
  final String content;

  factory RoomDetails.fromJson(Map<String, dynamic> json) {
    return RoomDetails(
      roomId: json['room_id'],
      messageId: json['id'],
      content: json['content'],
    );
  }

  RoomDetails({
    required this.roomId,
    required this.messageId,
    required this.content,
  });
}
