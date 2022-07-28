import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/logo.dart';

class SupportPage extends StatefulWidget {
  static String routeName = '/support';
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  bool _showEmail = false;

  void _launchEmail(
      BuildContext context, AppLocalizations appLocalization) async {
    try {
      Email email = Email(
          to: [supportEmail],
          subject: appLocalization.support_email_subject,
          body: '');
      await EmailLauncher.launch(email);
    } on PlatformException {
      context.showErrorSnackBar(
          message: appLocalization.email_client_not_found);
      setState(() {
        _showEmail = true;
      });
    } catch (error) {
      setState(() {
        _showEmail = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    child: Text(appLocalization.back),
                  ),
                ],
              ),
              const Logo(),
              const FormInputDivider(),
              Text(
                appLocalization.support_text_introduction,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const FormInputDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => _launchEmail(context, appLocalization),
                    child: _showEmail == true
                        ? const Text(supportEmail)
                        : Text(appLocalization.support),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    child: Text(appLocalization.back),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              const Footer(),
            ],
          ),
        ],
      ),
    );
  }
}
