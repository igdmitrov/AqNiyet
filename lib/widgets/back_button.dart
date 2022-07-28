import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants.dart';

class BackToPageButton extends StatelessWidget {
  const BackToPageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => navigatorKey.currentState!.pop(),
          child: Text(appLocalization.back),
        ),
      ],
    );
  }
}
