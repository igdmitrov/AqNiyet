import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/category.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';
import '../widgets/greeting.dart';
import '../widgets/menuitem_count_by_category.dart';
import 'account_page.dart';
import 'add_page.dart';
import 'city_page.dart';
import 'login_page.dart';
import 'my_adverts_page.dart';
import 'room_page.dart';
import 'support_page.dart';
import 'verify_email_page.dart';

class MainPage extends StatefulWidget {
  static String routeName = '/main';
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<List<Category>> _getCategories(
      BuildContext context, AppLocalizations appLocalization) async {
    try {
      return await context.read<AppService>().getCategoriesForMenu();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
            onPressed: () {
              if (isAuthenticated() && isEmail() == false) {
                Navigator.of(context).pushNamed(VerifyEmailPage.routeName);
                return;
              }

              Navigator.of(context).pushNamed(AddPage.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              title: const Greeting(),
              backgroundColor: appBackgroundColor,
              foregroundColor: appForegroundColor,
            ),
            const Divider(),
            if (isAuthenticated())
              ListTile(
                leading: const Icon(Icons.my_library_books),
                title: Text(appLocalization.my_items),
                onTap: () {
                  Navigator.of(context)
                      .popAndPushNamed(MyAdvertsPages.routeName);
                },
              ),
            if (isAuthenticated())
              ListTile(
                leading: const Icon(Icons.chat_bubble),
                title: Text(appLocalization.chat),
                onTap: () {
                  Navigator.of(context).popAndPushNamed(RoomPage.routeName);
                },
              ),
            if (isAuthenticated())
              ListTile(
                leading: const Icon(Icons.account_box),
                title: Text(appLocalization.my_account),
                onTap: () {
                  Navigator.of(context).popAndPushNamed(AccountPage.routeName);
                },
              ),
            ListTile(
              leading: const Icon(Icons.help_center),
              title: Text(appLocalization.support),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    SupportPage.routeName, (route) => false);
              },
            ),
            const Divider(),
            if (isUnauthenticated())
              ListTile(
                leading: const Icon(Icons.input_outlined),
                title: Text(appLocalization.signin),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginPage.routeName, (route) => false);
                },
              ),
            if (isAuthenticated())
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(appLocalization.logoff(getCurrentUserPhone())),
                onTap: () {
                  setState(() {
                    supabase.auth.signOut();
                  });
                },
              ),
          ],
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: _getCategories(context, appLocalization),
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
                    final category = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 3),
                      child: Card(
                        child: ListTile(
                          title: Text(category.name),
                          onTap: () => Navigator.of(context).pushNamed(
                              CityPage.routeName,
                              arguments: category),
                          trailing: MenuItemCountByCategory(category.id),
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
