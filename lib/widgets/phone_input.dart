import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;

  const PhoneInput(
      {Key? key, required this.controller, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: appLocalization.phone),
      autocorrect: false,
      validator: RequiredValidator(errorText: appLocalization.phone_required),
      enabled: !isLoading,
      keyboardType: TextInputType.phone,
      inputFormatters: [phoneMaskFormatter],
    );
  }
}
