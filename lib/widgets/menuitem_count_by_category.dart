import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_service.dart';

class MenuItemCountByCategory extends StatefulWidget {
  final String categoryId;
  const MenuItemCountByCategory(this.categoryId, {Key? key}) : super(key: key);

  @override
  State<MenuItemCountByCategory> createState() =>
      _MenuItemCountByCategoryState();
}

class _MenuItemCountByCategoryState extends State<MenuItemCountByCategory> {
  Future<int> _getCountByCategory(
      BuildContext context, String categoryId) async {
    try {
      return await context.read<AppService>().getCountByCategory(categoryId);
    } on Exception catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: _getCountByCategory(context, widget.categoryId),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            final num = snapshot.data as int;
            return Text(num.toString());
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Text('...');
        });
  }
}
