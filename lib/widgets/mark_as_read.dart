import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/message.dart';
import '../services/app_service.dart';

class MarkAsRead extends StatelessWidget {
  final Message message;
  final bool isMine;
  const MarkAsRead({
    Key? key,
    required this.message,
    required this.isMine,
  }) : super(key: key);

  final markRead = const Icon(
    Icons.mark_chat_read,
    color: Colors.indigo,
    size: 18.0,
  );

  final markUnRead = const Icon(
    Icons.mark_chat_unread,
    color: Colors.grey,
    size: 18.0,
  );

  Future<Widget> _getMark(BuildContext context) async {
    final appService = context.read<AppService>();

    if (isMine == false) {
      if (message.markAsRead == false) {
        await appService.markAsRead(message.id);
      }

      return const SizedBox.shrink();
    }

    if (isMine == true) {
      if (message.markAsRead == true) {
        return markRead;
      } else {
        return markUnRead;
      }
    }

    return markUnRead;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getMark(context),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data as Widget;
          }

          return markUnRead;
        });
  }
}
