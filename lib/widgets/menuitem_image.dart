import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/advert_menu_item.dart';
import '../services/app_service.dart';

class MenuItemImage extends StatefulWidget {
  final AdvertMenuItem menuItem;
  const MenuItemImage(this.menuItem, {Key? key}) : super(key: key);

  @override
  State<MenuItemImage> createState() => _MenuItemImageState();
}

class _MenuItemImageState extends State<MenuItemImage> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 44,
        minHeight: 44,
        maxWidth: 64,
        maxHeight: 64,
      ),
      child: FutureBuilder<Uint8List?>(
          future: context
              .read<AppService>()
              .getMainImage(widget.menuItem.id, widget.menuItem.createdBy),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                (snapshot.data as Uint8List),
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              );
            }
            return Container();
          }),
    );
  }
}
