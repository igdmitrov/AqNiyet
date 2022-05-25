import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/advert_menu_item.dart';
import '../services/app_service.dart';
import 'add_page.dart';
import 'advert_page.dart';

class MyAdvertsPages extends StatefulWidget {
  static String routeName = '/myadverts';
  const MyAdvertsPages({Key? key}) : super(key: key);

  @override
  State<MyAdvertsPages> createState() => _MyAdvertsPagesState();
}

class _MyAdvertsPagesState extends State<MyAdvertsPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My items'),
        actions: [
          IconButton(
            onPressed: () =>
                {Navigator.of(context).pushNamed(AddPage.routeName)},
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder<List<AdvertMenuItem>>(
        future: context.read<AppService>().getMyAdvertMenuItems(),
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
                        subtitle: Text(advert.description),
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
