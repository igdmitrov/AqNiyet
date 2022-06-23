import 'package:aqniyet/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/model_validator.dart';
import '../model/city.dart';
import 'lookup_form_input.dart';

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

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return LookupFormInput(
      name: appLocalization.city,
      isLoading: isLoading,
      asyncItems: (String? filter) => appService.getCities(filter: filter),
      onSaved: onSaved,
      validator: ModelValidator(errorText: appLocalization.city_required),
      selectedItem: selectedItem,
    );
  }
}
