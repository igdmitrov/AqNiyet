import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const appName = 'AqNiyet';
const footerText = 'DEVELOPED BY IGOR DMITROV';
const supportEmail = 'aqniyet.help@gmail.com';

final supabase = Supabase.instance.client;

const supabaseImageBucket = 'public-images';

const maxImageWidth = 640;
const maxImageIconWidth = 128;
const thumbnailPrefix = 'icon_';
const iconFileName = 'primary_icon.jpg';

const maxImages = 10;

Color? appBackgroundColor = Colors.grey.shade50;
Color? appForegroundColor = Colors.indigo;

bool isAuthenticated() {
  return supabase.auth.currentUser != null;
}

bool isUnauthenticated() {
  return isAuthenticated() == false;
}

String getCurrentUserPhone() {
  return isAuthenticated()
      ? formatedPhoneNumber(supabase.auth.currentUser!.phone)
      : '';
}

String getCurrentUserId() {
  return isAuthenticated() ? supabase.auth.currentUser!.id : '';
}

bool isEmail() {
  supabase.auth.refreshSession();

  return isAuthenticated() == true
      ? supabase.auth.currentUser!.email!.isNotEmpty
      : false;
}

String getUnverifiedEmail() {
  return isAuthenticated() == true
      ? supabase.auth.currentUser!.userMetadata['email']
      : '';
}

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

MultiValidator passwordValidator(AppLocalizations appLocalizations) {
  const minLengthPassword = 8;
  return MultiValidator([
    RequiredValidator(errorText: appLocalizations.password_required),
    MinLengthValidator(minLengthPassword,
        errorText: appLocalizations.password_length_error(minLengthPassword))
  ]);
}

MultiValidator emailValidator(AppLocalizations appLocalizations) {
  return MultiValidator([
    RequiredValidator(errorText: appLocalizations.email_required),
    EmailValidator(errorText: appLocalizations.valid_email),
  ]);
}

MultiValidator phoneValidator(AppLocalizations appLocalizations) {
  const phoneLength = 18;
  return MultiValidator([
    RequiredValidator(errorText: appLocalizations.phone_required),
    MinLengthValidator(phoneLength, errorText: appLocalizations.phone_incorrect)
  ]);
}

MultiValidator otpCodeValidator(AppLocalizations appLocalizations) {
  const otpCodeLength = 7;
  return MultiValidator([
    RequiredValidator(errorText: appLocalizations.otpcode_required),
    MinLengthValidator(otpCodeLength,
        errorText: appLocalizations.otpcode_incorrect)
  ]);
}

final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

final otpCodeMaskFormatter = MaskTextInputFormatter(
    mask: '###-###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

String formatPhoneNumber(String phone) {
  return phone
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll(' ', '')
      .replaceAll('-', '');
}

String formatOTPCode(String otpCode) {
  return otpCode.replaceAll('-', '');
}

String formatedPhoneNumber(String? phone) {
  String formattedNumber = '';

  if (phone == null) return formattedNumber;

  MagicMask mask = MagicMask.buildMask('\\+9 (999) 999-99-99');
  return mask.getMaskedString(phone);
}

String getUserAppName(String userId) {
  return userId.substring(0, 8).toUpperCase();
}

extension SharedExtension on SharedPreferences {
  bool checkKey(String key) {
    if (containsKey(key)) {
      if (containsKey('${key}_expire')) {
        final expDate =
            DateTime.fromMillisecondsSinceEpoch(getInt('${key}_expire') ?? 0);

        if (expDate.isAfter(DateTime.now())) {
          return true;
        }
      }
    }
    return false;
  }

  void toCacheList(String key, List<String> data,
      {Duration duration = const Duration(minutes: 10)}) {
    if (containsKey(key)) {
      remove(key);
      remove('${key}_expire');
    }

    setStringList(key, data);
    setInt(
        '${key}_expire', DateTime.now().add(duration).millisecondsSinceEpoch);
  }

  void toCacheBool(String key, bool value,
      {Duration duration = const Duration(minutes: 10)}) {
    if (containsKey(key)) {
      remove(key);
      remove('${key}_expire');
    }

    setBool(key, value);
    setInt(
        '${key}_expire', DateTime.now().add(duration).millisecondsSinceEpoch);
  }
}
