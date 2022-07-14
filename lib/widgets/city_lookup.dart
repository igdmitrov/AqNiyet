import 'dart:convert';

import 'package:aqniyet/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../components/model_validator.dart';
import '../components/shared_preferences_provider.dart';
import '../model/city.dart';
import 'lookup_form_input.dart';
import '../utils/constants.dart';

class CityLookup extends StatelessWidget {
  final bool isLoading;
  final AppService appService;
  final Function(City?) onSaved;
  final City? selectedItem;

  const CityLookup(
      {Key? key,
      required this.isLoading,
      required this.appService,
      required this.onSaved,
      this.selectedItem})
      : super(key: key);

  Future<List<City>> _getData(BuildContext context,
      AppLocalizations appLocalization, String? filter) async {
    const String cacheKey = 'city_list_all';
    final sharedProvider = context.read<SharedPreferencesProvider>();

    try {
      final sharedPrefs = await sharedProvider.sharedPreferences;
      if (sharedPrefs.checkKey(cacheKey)) {
        final cachedCities = sharedPrefs.getStringList(cacheKey);

        if (cachedCities != null) {
          return cachedCities
              .map((city) => City.fromJson(jsonDecode(city)))
              .toList()
              .where((element) =>
                  (filter == null || element.name.contains(filter)))
              .toList();
        }
      }

      final data = await appService.getCities(filter: filter);

      if (filter == null || filter.isEmpty) {
        sharedPrefs.toCacheList(
            cacheKey, data.map((city) => jsonEncode(city.toMap())).toList(),
            duration: const Duration(days: 1));
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
      name: appLocalization.city,
      isLoading: isLoading,
      asyncItems: (String? filter) =>
          _getData(context, appLocalization, filter),
      onSaved: onSaved,
      validator: ModelValidator(errorText: appLocalization.city_required),
      selectedItem: selectedItem,
    );
  }
}
