import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ConfirmPasswordInput extends StatelessWidget {
  final TextEditingController confirmController;
  final TextEditingController passwordController;
  final String password;
  final bool isLoading;

  const ConfirmPasswordInput(
      {Key? key,
      required this.isLoading,
      required this.password,
      required this.confirmController,
      required this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return TextFormField(
      controller: confirmController,
      decoration: InputDecoration(labelText: appLocalization.confirm_password),
      obscureText: true,
      enabled: !isLoading,
      validator: (val) =>
          MatchValidator(errorText: appLocalization.password_dont_match)
              .validateMatch(confirmController.text, passwordController.text),
    );
  }
}
