import 'package:flutter/material.dart';

import '../model/advert.dart';

class AdvertPage extends StatefulWidget {
  static String routeName = '/advert';
  const AdvertPage({Key? key}) : super(key: key);

  @override
  State<AdvertPage> createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  @override
  Widget build(BuildContext context) {
    final Advert advert = ModalRoute.of(context)!.settings.arguments as Advert;

    return Scaffold(
      appBar: AppBar(
        title: Text(advert.name),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          Text(advert.name),
          Text(advert.description),
          Text(advert.address),
        ],
      ),
    );
  }
}
