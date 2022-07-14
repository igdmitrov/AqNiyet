import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_service.dart';

class MenuItemCountByCategoryAndCity extends StatefulWidget {
  final String categoryId;
  final String cityId;
  const MenuItemCountByCategoryAndCity(this.categoryId, this.cityId, {Key? key})
      : super(key: key);

  @override
  State<MenuItemCountByCategoryAndCity> createState() =>
      _MenuItemCountByCategoryAndCityState();
}

class _MenuItemCountByCategoryAndCityState
    extends State<MenuItemCountByCategoryAndCity> {
  Future<int> _getCountByCategoryAndCity(
      BuildContext context, String categoryId, String cityId) async {
    try {
      return await context
          .read<AppService>()
          .getCountByCategoryAndCity(categoryId, cityId);
    } on Exception catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: _getCountByCategoryAndCity(
            context, widget.categoryId, widget.cityId),
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
