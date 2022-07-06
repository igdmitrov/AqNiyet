import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../widgets/back_button.dart';
import '../widgets/clause.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';

class PolicyPage extends StatelessWidget {
  static String routeName = '/policy';
  const PolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        children: [
          Column(
            children: [
              const BackToPageButton(),
              const BackToPageButton(),
              const Footer(),
            ],
          ),
        ],
      ),
    );
  }
}
