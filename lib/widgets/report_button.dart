import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/report_page.dart';
import '../utils/constants.dart';

class ReportButton extends StatelessWidget {
  final String advertId;
  final String? roomId;
  const ReportButton({Key? key, required this.advertId, this.roomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return OutlinedButton(
      onPressed: () => navigatorKey.currentState!.pushNamed(
          ReportPage.routeName,
          arguments: {'advert_id': advertId, 'room_id': roomId}),
      child: Text(
        appLocalization.report,
        style: const TextStyle(color: Colors.orange),
      ),
    );
  }
}
