class Report {
  final String advertId;
  final String? roomId;
  final String email;
  final String description;

  Report({
    required this.advertId,
    required this.email,
    required this.description,
    this.roomId,
  });

  Map toMap() {
    return {
      'advert_id': advertId,
      'room_id': roomId,
      'email': email,
      'description': description,
    };
  }
}
