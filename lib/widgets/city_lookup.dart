import 'package:aqniyet/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/model_validator.dart';
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
    try {
      return await appService.getCities(filter: filter);
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
