class AccountDelete {
  final String createdBy;

  AccountDelete({
    required this.createdBy,
  });

  Map toMap() {
    return {
      'created_by': createdBy,
    };
  }
}
