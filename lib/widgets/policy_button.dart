import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/policy_page.dart';
import '../utils/constants.dart';

class PolicyButton extends StatelessWidget {
  const PolicyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return TextButton(
      onPressed: () =>
          navigatorKey.currentState!.pushNamed(PolicyPage.routeName),
      child: Text(
        appLocalization.policy,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
