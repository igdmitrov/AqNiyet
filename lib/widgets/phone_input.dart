import 'package:flutter/material.dart';
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
      autofocus: true,
      decoration: InputDecoration(labelText: appLocalization.phone),
      autocorrect: false,
      validator: phoneValidator(appLocalization),
      enabled: !isLoading,
      keyboardType: TextInputType.phone,
      inputFormatters: [phoneMaskFormatter],
    );
  }
}
