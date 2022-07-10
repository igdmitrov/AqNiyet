class Report {
  final String advertId;
  final String email;
  final String description;

  Report(
      {required this.advertId, required this.email, required this.description});

  Map toMap() {
    return {
      'advert_id': advertId,
      'email': email,
      'description': description,
    };
  }
}
