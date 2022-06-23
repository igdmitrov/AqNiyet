import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants.dart';
import '../widgets/footer.dart';
import '../widgets/logo.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  static String routeName = '/signup';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _signUp(AppLocalizations appLocalizations) async {
    setState(() {
      _isLoading = true;
    });

    final isValid =
        _form.currentState == null ? false : _form.currentState!.validate();

    if (isValid) {
      final response = await supabase.auth
          .signUp(_emailController.text, _passwordController.text);
      final error = response.error;
      if (error != null) {
        if (!mounted) return;
        context.showErrorSnackBar(message: error.message);
      } else {
        if (!mounted) return;
        context.showSnackBar(message: appLocalizations.user_created);
        Navigator.of(context)
            .pushNamed(LoginPage.routeName, arguments: _emailController.text);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
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
                const SizedBox(height: 18),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: appLocalization.email),
                  validator: emailValidator(appLocalization),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _passwordController,
                  decoration:
                      InputDecoration(labelText: appLocalization.password),
                  obscureText: true,
                  validator: passwordValidator(appLocalization),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                      labelText: appLocalization.confirm_password),
                  obscureText: true,
                  validator: (val) => MatchValidator(
                          errorText: appLocalization.password_dont_match)
                      .validateMatch(_confirmPasswordController.text,
                          _passwordController.text),
                ),
                const SizedBox(height: 18),
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
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(LoginPage.routeName),
                      child: Text(appLocalization.signin),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
