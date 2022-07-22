import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/shared_preferences_provider.dart';
import '../model/message_metadata.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';

class MarkAsRead extends StatelessWidget {
  final String messageId;
  final bool isMine;
  final String receiver;
  const MarkAsRead(
      {Key? key,
      required this.messageId,
      required this.isMine,
      required this.receiver})
      : super(key: key);

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
    final String cacheKey = 'message_mark_as_read-$messageId';
    final appService = context.read<AppService>();
    final sharedProvider = context.read<SharedPreferencesProvider>();

    final sharedPrefs = await sharedProvider.sharedPreferences;
    if (sharedPrefs.checkKey(cacheKey)) {
      return markRead;
    } else {
      final markedAsRead = await appService.messageIsRead(
          messageId, isMine ? receiver : getCurrentUserId());

      if (markedAsRead == true) {
        sharedPrefs.toCacheBool(cacheKey, true,
            duration: const Duration(days: 365));

        return markRead;
      } else {
        await appService.markAsRead(MessageMetaData(
          messageId: messageId,
          markAsRead: true,
          createdBy: getCurrentUserId(),
        ));

        return markUnRead;
      }
    }
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
