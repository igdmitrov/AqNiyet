import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../components/auth_required_state.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';
import '../widgets/privacy_button.dart';
import '../widgets/remove_image_button.dart';

class AccountPage extends StatefulWidget {
  static String routeName = '/account';
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends AuthRequiredState<AccountPage> {
  bool isLoading = false;

  Future<void> _removeAccount(BuildContext context, AppService appService,
      AppLocalizations appLocalization) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await appService.removeAccount(getCurrentUserId());
      if (response.hasError == false) {
        supabase.auth.signOut();
      }
    } catch (error) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appService = context.read<AppService>();
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalization.my_account,
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              getCurrentUserPhone(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const PrivacyButton(),
          const SizedBox(height: 40),
          Text(
            appLocalization.question_remove_account,
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          RemoveImageButton(
            onPressed: () =>
                _removeAccount(context, appService, appLocalization),
            isLoading: isLoading,
          ),
        ],
      )),
    );
  }
}
