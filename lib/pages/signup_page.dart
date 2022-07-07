import 'package:aqniyet/widgets/confirm_password_input.dart';
import 'package:aqniyet/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants.dart';
import '../widgets/checkbox_form_input.dart';
import '../widgets/email_input.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/logo.dart';
import '../widgets/phone_input.dart';
import '../widgets/policy_button.dart';
import '../widgets/privacy_button.dart';
import 'login_page.dart';
import 'verify_page.dart';

class SignUpPage extends StatefulWidget {
  static String routeName = '/signup';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _confirm = false;

  Future<void> _signUp(AppLocalizations appLocalizations) async {
    setState(() {
      _isLoading = true;
    });

    final isValid =
        _form.currentState == null ? false : _form.currentState!.validate();

    if (isValid) {
      _form.currentState!.save();
    }

    if (_confirm == false) {
      context.showErrorSnackBar(message: appLocalizations.unconfirmed_privacy);
    }

    if (isValid && _confirm == true) {
      final formatedPhoneNumber = formatPhoneNumber(_phoneController.text);
      final response = await supabase.auth.signUpWithPhone(
          formatedPhoneNumber, _passwordController.text,
          userMetadata: {'email': _emailController.text});
      final error = response.error;
      if (error != null) {
        if (!mounted) return;
        context.showErrorSnackBar(message: error.message);
      } else {
        if (!mounted) return;
        Navigator.of(context)
            .pushNamed(VerifyPage.routeName, arguments: _phoneController.text);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
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
                const Logo(),
                PhoneInput(
                  controller: _phoneController,
                  isLoading: _isLoading,
                ),
                const FormInputDivider(),
                EmailInput(
                  controller: _emailController,
                  isLoading: _isLoading,
                ),
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
                const PrivacyButton(),
                const PolicyButton(),
                CheckboxFormInput(
                  title: appLocalization.privacy_confirm_text,
                  onSaved: (val) {
                    _confirm = val ?? false;
                  },
                  enabled: _isLoading,
                  initialValue: _confirm,
                ),
                const FormInputDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => _signUp(appLocalization),
                      child: Text(_isLoading
                          ? appLocalization.loading
                          : appLocalization.signup),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(LoginPage.routeName),
                      child: Text(appLocalization.signin),
                    ),
                  ],
                ),
                const FormInputDivider(),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
