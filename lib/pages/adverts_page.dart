import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/advert_menu_item.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../services/app_service.dart';
import 'add_page.dart';
import 'advert_page.dart';

class AdvertsPage extends StatefulWidget {
  static String routeName = '/adverts';

  const AdvertsPage({Key? key}) : super(key: key);

  @override
  State<AdvertsPage> createState() => _AdvertsPageState();
}

class _AdvertsPageState extends State<AdvertsPage> {
  @override
  Widget build(BuildContext context) {
    final parematers =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Category category = parematers['category'];
    final City city = parematers['city'];

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
      body: FutureBuilder<List<AdvertMenuItem>>(
        future:
            context.read<AppService>().getAdvertMenuItems(category.id, city.id),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final advert = snapshot.data![index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                    child: Card(
                      child: ListTile(
                        title: Text(advert.name),
                        subtitle: Text(
                            advert.description.characters.take(50).toString()),
                        onTap: () => Navigator.of(context)
                            .pushNamed(AdvertPage.routeName, arguments: advert),
                        trailing: Text(timeago.format(advert.createdAt)),
                      ),
                    ),
                  );
                });
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
