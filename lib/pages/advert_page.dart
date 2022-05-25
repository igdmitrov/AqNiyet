import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/advert_menu_item.dart';
import '../model/advert_page_view.dart';
import '../services/app_service.dart';

class AdvertPage extends StatefulWidget {
  static String routeName = '/advert';
  const AdvertPage({Key? key}) : super(key: key);

  @override
  State<AdvertPage> createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  @override
  Widget build(BuildContext context) {
    final advertMenuItem =
        ModalRoute.of(context)!.settings.arguments as AdvertMenuItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(advertMenuItem.name),
      ),
      body: FutureBuilder<AdvertPageView>(
          future:
              context.read<AppService>().getAdvertPageView(advertMenuItem.id),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              final advert = snapshot.data as AdvertPageView;
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  Text(advert.name),
                  Text(advert.description),
                  Text(advert.address),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
