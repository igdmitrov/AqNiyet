import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/report_page.dart';

class ReportButton extends StatelessWidget {
  final String advertId;
  const ReportButton({Key? key, required this.advertId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return OutlinedButton(
      onPressed: () => Navigator.of(context)
          .pushNamed(ReportPage.routeName, arguments: advertId),
      child: Text(
        appLocalization.report,
        style: const TextStyle(color: Colors.orange),
      ),
    );
  }
}
