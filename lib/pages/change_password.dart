import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/constants.dart';
import '../widgets/confirm_password_input.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/logo.dart';
import '../widgets/password_input.dart';

class ChangePassword extends StatefulWidget {
  static String routeName = '/change-password';
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _changePassword(AppLocalizations appLocalization) async {
    setState(() {
      _isLoading = true;
    });

    final isValid =
        _form.currentState == null ? false : _form.currentState!.validate();

    if (isValid) {
      final response = await supabase.auth
          .update(UserAttributes(password: _passwordController.text));

      final error = response.error;
      if (error != null) {
        if (!mounted) return;
        context.showErrorSnackBar(message: error.message);
      } else {
        if (!mounted) return;
        context.showSnackBar(message: appLocalization.password_changed);
        supabase.auth.signOut();
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                      onPressed: () => navigatorKey.currentState!.pop(),
                      child: Text(appLocalization.back),
                    ),
                  ],
                ),
                const Logo(),
                const FormInputDivider(),
                PasswordInput(
                  controller: _passwordController,
                  isLoading: _isLoading,
                ),
                const FormInputDivider(),
                ConfirmPasswordInput(
                  confirmController: _confirmPasswordController,
                  passwordController: _passwordController,
                  isLoading: _isLoading,
                  password: _passwordController.text,
                ),
                const FormInputDivider(),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _changePassword(appLocalization),
                  child: Text(_isLoading
                      ? appLocalization.loading
                      : appLocalization.confirm),
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
