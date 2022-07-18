import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/auth_required_state.dart';
import '../utils/constants.dart';
import '../widgets/app_title.dart';
import '../widgets/policy_button.dart';
import '../widgets/privacy_button.dart';
import '../widgets/remove_image_button.dart';
import 'change_password.dart';
import 'remove_account_page.dart';

class AccountPage extends StatefulWidget {
  static String routeName = '/account';
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends AuthRequiredState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalization.my_account,
        ),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 10),
          const AppTitle(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              getCurrentUserPhone(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          RemoveImageButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(RemoveAccountPage.routeName),
            isLoading: false,
          ),
          const SizedBox(height: 40),
          OutlinedButton(
            child: Text(appLocalization.change_password),
            onPressed: () =>
                Navigator.of(context).pushNamed(ChangePassword.routeName),
          ),
          const SizedBox(height: 40),
          const PrivacyButton(),
          const PolicyButton(),
        ],
      )),
    );
  }
}
