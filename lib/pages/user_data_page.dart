import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/constants.dart';
import '../widgets/email_input.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/logo.dart';
import 'add_page.dart';
import 'main_page.dart';

class UserDataPage extends StatefulWidget {
  static String routeName = '/userdata';
  const UserDataPage({Key? key}) : super(key: key);

  @override
  State<UserDataPage> createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _saveUserData() async {
    setState(() {
      _isLoading = true;
    });

    final isValid =
        _form.currentState == null ? false : _form.currentState!.validate();

    if (isValid) {
      final response = await supabase.auth
          .update(UserAttributes(email: _emailController.text));

      final error = response.error;
      if (error != null) {
        if (!mounted) return;
        context.showErrorSnackBar(message: error.message);
      } else {
        if (!mounted) return;
        navigatorKey.currentState!.pushReplacementNamed(AddPage.routeName);
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
                      onPressed: () => navigatorKey.currentState!
                          .pushNamed(MainPage.routeName),
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
                  onPressed: _isLoading ? null : _saveUserData,
                  child: Text(_isLoading
                      ? appLocalization.loading
                      : appLocalization.save),
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
