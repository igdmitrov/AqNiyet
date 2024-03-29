import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/privacy_page.dart';
import '../utils/constants.dart';

class PrivacyButton extends StatelessWidget {
  const PrivacyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return TextButton(
      onPressed: () =>
          navigatorKey.currentState!.pushNamed(PrivacyPage.routeName),
      child: Text(
        appLocalization.privacy,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
