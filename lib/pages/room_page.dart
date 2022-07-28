import 'package:aqniyet/widgets/user_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/room.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';
import 'chat_page.dart';

class RoomPage extends StatefulWidget {
  static String routeName = '/room';
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<List<Room>> _getRooms(
      BuildContext context, AppLocalizations appLocalization) async {
    try {
      return await context.read<AppService>().getRooms(getCurrentUserId());
    } on Exception catch (_) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }

    return [];
  }

  Future<bool> _getStatusUnReadMessages(
      BuildContext context, String roomId) async {
    try {
      return await context
              .read<AppService>()
              .getCountUnreadMessagesByRoom(roomId, getCurrentUserId()) >
          0;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;
    final Locale appLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalization.chat),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<List<Room>>(
        future: _getRooms(context, appLocalization),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              key: refreshKey,
              onRefresh: _refresh,
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final room = snapshot.data![index];
                    return Padding(
                      key: ValueKey(index),
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 3),
                      child: Card(
                        child: ListTile(
                          leading: FutureBuilder<bool>(
                              future:
                                  _getStatusUnReadMessages(context, room.id),
                              builder: (ctx, snapshot) {
                                if (snapshot.hasData && snapshot.data == true) {
                                  return const Icon(
                                    Icons.circle,
                                    color: Colors.indigo,
                                    size: 16.0,
                                  );
                                }

                                return UserLogo(userId: room.userFrom);
                              }),
                          title: Text(
                            getUserAppName(room.userFrom),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              room.advertName.characters.take(50).toString()),
                          onTap: () async {
                            await navigatorKey.currentState!
                                .pushNamed(ChatPage.routeName, arguments: room);

                            refreshKey.currentState!.show();
                          },
                          trailing: Text(
                            timeago.format(
                              room.createdAt,
                              locale: appLocale.languageCode,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
