import 'package:aqniyet/model/phonecode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/model_validator.dart';
import '../services/app_service.dart';
import 'lookup_form_input.dart';

class PhonecodeLookup extends StatelessWidget {
  final bool isLoading;
  final AppService appService;
  final Function(PhoneCode?) onSaved;
  final PhoneCode? selectedItem;

  const PhonecodeLookup(
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
      name: appLocalization.phonecode,
      isLoading: isLoading,
      asyncItems: (String? filter) => appService.getPhoneCodes(filter: filter),
      onSaved: onSaved,
      validator: ModelValidator(errorText: appLocalization.phonecode_required),
      selectedItem: selectedItem ??
          PhoneCode(
              id: 'e6944e99-37be-4890-8433-84a73e74e0bc',
              code: '+7',
              countryName: 'kz'),
    );
  }
}
