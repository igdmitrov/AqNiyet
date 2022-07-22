import 'package:aqniyet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/message.dart';
import 'mark_as_read.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final Locale appLocale = Localizations.localeOf(context);
    final bool isMine = message.isMine(getCurrentUserId());

    List<Widget> chatContents = [
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: isMine ? Colors.grey[600] : Colors.indigo[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.content,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(
        timeago.format(
          message.createdAt,
          locale: appLocale.languageCode,
        ),
        style: const TextStyle(color: Colors.grey, fontSize: 12.0),
      ),
      MarkAsRead(
        messageId: message.id,
        isMine: isMine,
        receiver: message.userTo,
      ),
      const SizedBox(width: 60),
    ];
    if (isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
