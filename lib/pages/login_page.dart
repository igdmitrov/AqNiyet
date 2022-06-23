import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/constants.dart';
import '../widgets/footer.dart';
import '../widgets/logo.dart';
import 'main_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final isValid =
        _form.currentState == null ? false : _form.currentState!.validate();

    if (isValid) {
      final response = await supabase.auth.signIn(
          email: _emailController.text, password: _passwordController.text);
      final error = response.error;
      if (error != null) {
        if (!mounted) return;
        context.showErrorSnackBar(message: error.message);
      } else {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(MainPage.routeName);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? emailFromSignUp =
        ModalRoute.of(context)!.settings.arguments as String?;

    _emailController.text = emailFromSignUp ?? '';

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
                          Navigator.of(context).pushNamed(MainPage.routeName),
                      child: Text(appLocalization.back),
                    ),
                  ],
                ),
                const Logo(),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: appLocalization.email),
                  enabled: !_isLoading,
                  validator: emailValidator(appLocalization),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _passwordController,
                  decoration:
                      InputDecoration(labelText: appLocalization.password),
                  obscureText: true,
                  enabled: !_isLoading,
                  validator: passwordValidator(appLocalization),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: Text(_isLoading
                          ? appLocalization.loading
                          : appLocalization.signin),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () => _isLoading
                          ? null
                          : Navigator.of(context)
                              .pushNamed(SignUpPage.routeName),
                      child: Text(appLocalization.signup),
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
