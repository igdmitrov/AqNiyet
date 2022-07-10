import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/advert_menu_item.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../services/app_service.dart';
import '../widgets/empty_list.dart';
import '../widgets/menuitem_image.dart';
import 'add_page.dart';
import 'advert_page.dart';
import '../utils/constants.dart';

class AdvertsPage extends StatefulWidget {
  static String routeName = '/adverts';

  const AdvertsPage({Key? key}) : super(key: key);

  @override
  State<AdvertsPage> createState() => _AdvertsPageState();
}

class _AdvertsPageState extends State<AdvertsPage> {
  Future<List<AdvertMenuItem>> _getAdvertMenuItems(
      BuildContext context,
      AppLocalizations appLocalization,
      String categoryId,
      String cityId) async {
    try {
      return await context
          .read<AppService>()
          .getAdvertMenuItems(categoryId, cityId);
    } on Exception catch (_) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final parematers =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Category category = parematers['category'];
    final City city = parematers['city'];

    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AddPage.routeName),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder<List<AdvertMenuItem>>(
        future:
            _getAdvertMenuItems(context, appLocalization, category.id, city.id),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const EmptyList();
            }

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final advert = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 3),
                      child: Card(
                        child: ListTile(
                          title: Text(advert.name),
                          leading: MenuItemImage(advert),
                          subtitle: Text(advert.description.characters
                              .take(50)
                              .toString()),
                          onTap: () => Navigator.of(context).pushNamed(
                              AdvertPage.routeName,
                              arguments: advert),
                          trailing: Text(timeago.format(advert.createdAt)),
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
