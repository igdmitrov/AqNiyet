import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/add_page.dart';
import '../pages/verify_email_page.dart';
import '../utils/constants.dart';
import 'form_input_divider.dart';
import 'logo.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Column(
      children: [
        const Logo(),
        const FormInputDivider(),
        Text(
          appLocalization.empty_list_text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const FormInputDivider(),
        ElevatedButton(
          onPressed: () {
            if (isAuthenticated() && isEmail() == false) {
              Navigator.of(context).pushNamed(VerifyEmailPage.routeName);
              return;
            }

            Navigator.of(context).pushNamed(AddPage.routeName);
          },
          child: Text(appLocalization.new_advert),
        ),
      ],
    );
  }
}
