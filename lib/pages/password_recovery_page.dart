import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';
import '../widgets/email_input.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/logo.dart';
import 'login_page.dart';

class PasswordRecoveryPage extends StatefulWidget {
  static String routeName = '/password-recovery';
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _recoveryPassword(AppLocalizations appLocalization) async {
    setState(() {
      _isLoading = true;
    });

    final isValid =
        _form.currentState == null ? false : _form.currentState!.validate();

    if (isValid) {
      final response =
          await supabase.auth.api.resetPasswordForEmail(_emailController.text);

      final error = response.error;
      if (error != null) {
        if (!mounted) return;
        context.showErrorSnackBar(message: error.message);
      } else {
        if (!mounted) return;
        context.showSnackBar(message: appLocalization.check_your_email);
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        children: [
          Form(
            key: _form,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(LoginPage.routeName),
                      child: Text(appLocalization.back),
                    ),
                  ],
                ),
                const Logo(),
                EmailInput(
                  controller: _emailController,
                  isLoading: _isLoading,
                ),
                const FormInputDivider(),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _recoveryPassword(appLocalization),
                  child: Text(_isLoading
                      ? appLocalization.loading
                      : appLocalization.password_recovery),
                ),
                SizedBox(height: 10.h),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
