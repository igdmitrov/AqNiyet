import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/category.dart';
import '../model/city.dart';
import '../services/app_service.dart';
import 'add_page.dart';
import 'adverts_page.dart';

class CityPage extends StatefulWidget {
  static String routeName = '/city';
  const CityPage({Key? key}) : super(key: key);

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  @override
  Widget build(BuildContext context) {
    final Category category =
        ModalRoute.of(context)!.settings.arguments as Category;

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
        future: context.read<AppService>().getCity(null),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final city = snapshot.data![index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                    child: Card(
                      child: ListTile(
                        title: Text(city.name),
                        onTap: () => Navigator.of(context).pushNamed(
                            AdvertsPage.routeName,
                            arguments: {'category': category, 'city': city}),
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
