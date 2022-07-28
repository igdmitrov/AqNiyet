import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/logo.dart';
import 'main_page.dart';
import 'support_page.dart';

class VerifyEmailPage extends StatefulWidget {
  static String routeName = '/verify-email';
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isLoading = false;

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });

    await supabase.auth.refreshSession();

    if (isAuthenticated() && isEmail() == true) {
      if (!mounted) return;
      navigatorKey.currentState!.pop();
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () =>
                    navigatorKey.currentState!.pushNamed(MainPage.routeName),
                child: Text(appLocalization.back),
              ),
            ],
          ),
          const Logo(),
          const FormInputDivider(),
          Text(
            appLocalization.confirm_email_address,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            getUnverifiedEmail(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const FormInputDivider(),
          Image.asset(
            'assets/images/email_confirm.png',
            height: 10.h,
          ),
          const FormInputDivider(),
          ElevatedButton(
            onPressed: _isLoading ? null : _refresh,
            child: Text(
                _isLoading ? appLocalization.loading : appLocalization.refresh),
          ),
          const FormInputDivider(),
          TextButton.icon(
            onPressed: () =>
                navigatorKey.currentState!.pushNamed(SupportPage.routeName),
            icon: const Icon(Icons.help_center),
            label: Text(appLocalization.support),
          ),
          SizedBox(height: 10.h),
          const Footer(),
        ],
      ),
    );
  }
}
