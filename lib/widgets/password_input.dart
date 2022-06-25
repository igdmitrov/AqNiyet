import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;

  const PasswordInput(
      {Key? key, required this.controller, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: appLocalization.password),
      obscureText: true,
      enabled: !isLoading,
      validator: passwordValidator(appLocalization),
    );
  }
}
