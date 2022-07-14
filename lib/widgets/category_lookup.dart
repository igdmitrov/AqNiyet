import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../components/model_validator.dart';
import '../components/shared_preferences_provider.dart';
import '../model/category.dart';
import '../services/app_service.dart';
import 'lookup_form_input.dart';
import '../utils/constants.dart';

class CategoryLookup extends StatelessWidget {
  final bool isLoading;
  final AppService appService;
  final Function(Category?) onSaved;
  final Category? selectedItem;

  const CategoryLookup(
      {Key? key,
      required this.isLoading,
      required this.appService,
      required this.onSaved,
      this.selectedItem})
      : super(key: key);

  Future<List<Category>> _getData(BuildContext context,
      AppLocalizations appLocalization, String? filter) async {
    final sharedProvider = context.read<SharedPreferencesProvider>();

    const String cacheKey = 'category_list_all';

    try {
      final sharedPrefs = await sharedProvider.sharedPreferences;
      if (sharedPrefs.checkKey(cacheKey)) {
        final cachedCategories = sharedPrefs.getStringList(cacheKey);

        if (cachedCategories != null) {
          return cachedCategories
              .map((category) => Category.fromJson(jsonDecode(category)))
              .toList()
              .where((element) =>
                  (filter == null || element.name.contains(filter)))
              .toList();
        }
      }

      final data = await appService.getCategories(filter: filter);

      if (filter == null || filter.isEmpty) {
        sharedPrefs.toCacheList(cacheKey,
            data.map((category) => jsonEncode(category.toMap())).toList());
      }

      return data;
    } on Exception catch (_) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return LookupFormInput(
      name: appLocalization.category,
      isLoading: isLoading,
      asyncItems: (String? filter) =>
          _getData(context, appLocalization, filter),
      onSaved: onSaved,
      validator: ModelValidator(errorText: appLocalization.category_required),
      selectedItem: selectedItem,
    );
  }
}
