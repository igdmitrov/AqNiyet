import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;

  const EmailInput(
      {Key? key, required this.controller, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return TextFormField(
      controller: controller,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: appLocalization.email),
      enabled: !isLoading,
      validator: emailValidator(appLocalization),
    );
  }
}
