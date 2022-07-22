class MessageMetaData {
  final String messageId;
  final bool markAsRead;
  final String createdBy;

  MessageMetaData({
    required this.messageId,
    required this.markAsRead,
    required this.createdBy,
  });

  Map toMap() {
    return {
      'message_id': messageId,
      'mark_as_read': markAsRead,
      'created_by': createdBy,
    };
  }
}
