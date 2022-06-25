import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants.dart';

class OTPCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;

  const OTPCodeInput(
      {Key? key, required this.controller, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return TextFormField(
      autofocus: true,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      controller: controller,
      enabled: !isLoading,
      decoration: InputDecoration(labelText: appLocalization.otp_code),
      inputFormatters: [otpCodeMaskFormatter],
      validator: otpCodeValidator(appLocalization)
    );
  }
}
