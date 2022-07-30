import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/room_build.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';
import '../widgets/user_logo.dart';
import 'chat_page.dart';

class RoomPage extends StatefulWidget {
  static String routeName = '/room';
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<RoomBuild> _getRooms(
      BuildContext context, AppLocalizations appLocalization) async {
    final userId = getCurrentUserId();
    final appService = context.read<AppService>();

    try {
      final roomDetails = await appService.getRoomDetails(userId);
      final rooms = await appService.getRooms(userId);

      return RoomBuild(rooms, roomDetails);
    } on Exception catch (_) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }

    return RoomBuild([], []);
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
      body: FutureBuilder<RoomBuild>(
        future: _getRooms(context, appLocalization),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              key: refreshKey,
              onRefresh: _refresh,
              child: ListView.builder(
                  itemCount: snapshot.data!.getCount(),
                  itemBuilder: (BuildContext context, int index) {
                    final roomBuild = snapshot.data!;
                    final room = roomBuild.getActiveRooms()[index];
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
                            roomBuild.lastMessage(room.id),
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
