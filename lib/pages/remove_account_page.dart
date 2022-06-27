import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../services/app_service.dart';
import '../utils/constants.dart';
import '../widgets/remove_image_button.dart';

class RemoveAccountPage extends StatefulWidget {
  static String routeName = '/remove-account';
  const RemoveAccountPage({Key? key}) : super(key: key);

  @override
  State<RemoveAccountPage> createState() => _RemoveAccountPageState();
}

class _RemoveAccountPageState extends State<RemoveAccountPage> {
  bool _isLoading = false;

  Future<void> _removeAccount(BuildContext context, AppService appService,
      AppLocalizations appLocalization) async {
    setState(() {
      _isLoading = true;
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
      _isLoading = false;
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
              appLocalization.remove_account_description,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RemoveImageButton(
                onPressed: () =>
                    _removeAccount(context, appService, appLocalization),
                isLoading: _isLoading,
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () =>
                    _isLoading ? null : Navigator.of(context).pop(),
                child: Text(appLocalization.cancel),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      )),
    );
  }
}
