import 'package:aqniyet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/advert_menu_item.dart';
import '../services/app_service.dart';
import '../widgets/menuitem_image.dart';
import 'add_page.dart';
import 'advert_page.dart';
import 'room_page.dart';

class MyAdvertsPages extends StatefulWidget {
  static String routeName = '/myadverts';
  const MyAdvertsPages({Key? key}) : super(key: key);

  @override
  State<MyAdvertsPages> createState() => _MyAdvertsPagesState();
}

class _MyAdvertsPagesState extends State<MyAdvertsPages> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<List<AdvertMenuItem>> _getMyAdvertMenuItems(BuildContext context,
      AppLocalizations appLocalization, String userId) async {
    try {
      return await context.read<AppService>().getMyAdvertMenuItems(userId);
    } on Exception catch (_) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }

    return [];
  }

  Future<bool> _getStatusUnReadMessages(BuildContext context) async {
    try {
      return await context
              .read<AppService>()
              .getCountUnreadMessages(getCurrentUserId()) >
          0;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;
    final Locale appLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalization.my_items),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
        actions: [
          if (isAuthenticated() && isEmail() == true)
            FutureBuilder<bool>(
                future: _getStatusUnReadMessages(context),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return IconButton(
                      onPressed: () async {
                        await Navigator.of(context)
                            .pushNamed(RoomPage.routeName);

                        refreshKey.currentState!.show();
                      },
                      icon: const Icon(
                        Icons.notification_add,
                        color: Colors.red,
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                }),
          IconButton(
            onPressed: () =>
                {Navigator.of(context).pushNamed(AddPage.routeName)},
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder<List<AdvertMenuItem>>(
        future:
            _getMyAdvertMenuItems(context, appLocalization, getCurrentUserId()),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              key: refreshKey,
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final advert = snapshot.data![index];
                    return Padding(
                      key: ValueKey(index),
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 3),
                      child: Card(
                        child: ListTile(
                          title: Text(advert.name),
                          leading: MenuItemImage(advert),
                          subtitle: Text(advert.description),
                          onTap: () => Navigator.of(context).pushNamed(
                              AdvertPage.routeName,
                              arguments: advert),
                          trailing: Text(timeago.format(
                            advert.createdAt,
                            locale: appLocale.languageCode,
                          )),
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
