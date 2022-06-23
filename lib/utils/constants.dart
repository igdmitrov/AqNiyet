import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const appName = 'AqNiyet';
const footerText = 'DEVELOPED BY IGOR DMITROV';

final supabase = Supabase.instance.client;

const maxImageWidth = 800;

bool isAuthenticated() {
  return supabase.auth.currentUser != null;
}

bool isUnauthenticated() {
  return isAuthenticated() == false;
}

String getCurrentUserEmail() {
  return isAuthenticated() ? supabase.auth.currentUser!.email ?? '' : '';
}

String getCurrentUserId() {
  return isAuthenticated() ? supabase.auth.currentUser!.id : '';
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

final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);
