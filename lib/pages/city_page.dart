import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/category.dart';
import '../model/city.dart';
import '../services/app_service.dart';
import '../widgets/menuitem_count_by_category_and_city.dart';
import 'add_page.dart';
import 'adverts_page.dart';
import '../utils/constants.dart';

class CityPage extends StatefulWidget {
  static String routeName = '/city';
  const CityPage({Key? key}) : super(key: key);

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  Future<List<City>> _getCities(
      BuildContext context, AppLocalizations appLocalization) async {
    try {
      return await context.read<AppService>().getCities();
    } on Exception catch (_) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AddPage.routeName),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder<List<City>>(
        future: _getCities(context, appLocalization),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final city = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 3),
                      child: Card(
                        child: ListTile(
                          title: Text(city.name),
                          onTap: () => Navigator.of(context).pushNamed(
                              AdvertsPage.routeName,
                              arguments: {'category': category, 'city': city}),
                          trailing: MenuItemCountByCategoryAndCity(
                              category.id, city.id),
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
