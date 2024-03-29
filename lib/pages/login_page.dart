import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/logo.dart';
import '../widgets/phone_input.dart';
import 'main_page.dart';
import 'password_recovery_page.dart';
import 'signup_page.dart';
import 'verify_page.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final isValid =
        _form.currentState == null ? false : _form.currentState!.validate();

    if (isValid) {
      final response = await supabase.auth.signIn(
          phone: formatPhoneNumber(_phoneController.text),
          password: _passwordController.text);
      final error = response.error;
      if (error != null) {
        if (!mounted) return;

        if (error.message == 'Phone not confirmed') {
          navigatorKey.currentState!.pushNamed(VerifyPage.routeName,
              arguments: _phoneController.text);
        }
        context.showErrorSnackBar(message: error.message);
      } else {
        if (!mounted) return;
        if (isAuthenticated() && isEmail() == false) {
          final email = supabase.auth.currentUser?.userMetadata['email'];
          await supabase.auth.update(UserAttributes(email: email));
        }

        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          badge: false,
          provisional: false,
          sound: true,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          if (kDebugMode) {
            print('User granted permission');
          }
          String? token = await messaging.getToken();
          if (token != null) {
            await supabase
                .rpc('update_fcm_key', params: {'key': token}).execute();
          }
        } else {
          if (kDebugMode) {
            print('User declined or has not accepted permission');
          }
        }

        if (!mounted) return;
        navigatorKey.currentState!.pushReplacementNamed(MainPage.routeName);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? phoneFromSignUp =
        ModalRoute.of(context)!.settings.arguments as String?;

    _phoneController.text = phoneFromSignUp ?? _phoneController.text;

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
                      onPressed: () => navigatorKey.currentState!
                          .pushNamed(MainPage.routeName),
                      child: Text(appLocalization.back),
                    ),
                  ],
                ),
                const Logo(),
                PhoneInput(
                  controller: _phoneController,
                  isLoading: _isLoading,
                ),
                const FormInputDivider(),
                TextFormField(
                  controller: _passwordController,
                  decoration:
                      InputDecoration(labelText: appLocalization.password),
                  obscureText: true,
                  enabled: !_isLoading,
                  validator: passwordValidator(appLocalization),
                ),
                const FormInputDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: Text(_isLoading
                          ? appLocalization.loading
                          : appLocalization.signin),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => _isLoading
                          ? null
                          : navigatorKey.currentState!
                              .pushNamed(SignUpPage.routeName),
                      child: Text(appLocalization.signup),
                    ),
                  ],
                ),
                const FormInputDivider(),
                TextButton(
                  onPressed: () => navigatorKey.currentState!
                      .pushNamed(PasswordRecoveryPage.routeName),
                  child: Text(
                    appLocalization.password_recovery,
                    style: const TextStyle(color: Colors.grey),
                  ),
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
