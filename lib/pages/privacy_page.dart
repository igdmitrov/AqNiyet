import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';

class PrivacyPage extends StatelessWidget {
  static String routeName = '/privacy';
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    final backButton = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLocalization.back),
        ),
      ],
    );

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        children: [
          Column(
            children: [
              backButton,
              const Text('Privacy ... '),
              backButton,
              const FormInputDivider(),
              const Footer(),
            ],
          ),
        ],
      ),
    );
  }
}
