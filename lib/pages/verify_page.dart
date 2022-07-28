import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../services/app_service.dart';
import '../utils/constants.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/logo.dart';
import '../widgets/otp_code_input.dart';
import 'login_page.dart';
import 'support_page.dart';

class VerifyPage extends StatefulWidget {
  static String routeName = '/verify';
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  int _timeFromLastSend = 60;
  Timer? _timer;
  final TextEditingController _otpCodeController = TextEditingController();

  void _startTimer() {
    _timeFromLastSend = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeFromLastSend == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _timeFromLastSend--;
          });
        }
      },
    );
  }

  Future<void> _verify(AppLocalizations appLocalizations, String phone) async {
    setState(() {
      _isLoading = true;
    });

    final isValid =
        _form.currentState == null ? false : _form.currentState!.validate();

    if (isValid) {
      final response = await supabase.auth.verifyOTP(
          formatPhoneNumber(phone), formatOTPCode(_otpCodeController.text));

      final error = response.error;
      if (error != null) {
        if (!mounted) return;
        context.showErrorSnackBar(message: error.message);
      } else {
        if (!mounted) return;
        navigatorKey.currentState!
            .pushNamed(LoginPage.routeName, arguments: phone);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _resendCode(
      AppLocalizations appLocalizations, String phone) async {
    setState(() {
      _isLoading = true;
      _otpCodeController.text = '';
    });

    final response = await context.read<AppService>().sendOTPCode(phone);

    final error = response.error;
    if (error != null) {
      if (!mounted) return;
      context.showErrorSnackBar(message: error.message);
    } else {
      if (!mounted) return;
      context.showSnackBar(message: appLocalizations.otp_was_sent);
      _startTimer();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;
    final phone = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        children: [
          Form(
            key: _form,
            child: Column(
              children: [
                const Logo(),
                OTPCodeInput(
                  controller: _otpCodeController,
                  isLoading: _isLoading,
                ),
                const FormInputDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _verify(appLocalization, phone),
                      child: Text(_isLoading
                          ? appLocalization.loading
                          : appLocalization.confirm),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => navigatorKey.currentState!
                          .pushNamed(LoginPage.routeName),
                      child: Text(appLocalization.cancel),
                    ),
                  ],
                ),
                const FormInputDivider(),
                TextButton(
                    onPressed: _timeFromLastSend == 0
                        ? () => _resendCode(appLocalization, phone)
                        : null,
                    child: Text(_timeFromLastSend == 0
                        ? appLocalization.resend
                        : '${appLocalization.resend} - $_timeFromLastSend ${appLocalization.sec}')),
                const FormInputDivider(),
                TextButton.icon(
                  onPressed: () => navigatorKey.currentState!
                      .pushNamed(SupportPage.routeName),
                  icon: const Icon(Icons.help_center),
                  label: Text(appLocalization.support),
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
