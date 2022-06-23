import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Greeting extends StatelessWidget {
  const Greeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    if (hour > 4 && hour < 12) {
      return Text(appLocalization.goodmorning);
    }
    if (hour < 19) {
      return Text(appLocalization.goodafternoon);
    }

    if (hour >= 19 && hour < 23) {
      return Text(appLocalization.goodevening);
    }

    return Text(appLocalization.goodnight);
  }
}
