import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

bool isAuthenticated() {
  return supabase.auth.currentUser != null;
}

String? getCurrentUserEmail() {
  return isAuthenticated() ? supabase.auth.currentUser!.email : null;
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

MultiValidator passwordValidator() {
  const _minLengthPassword = 8;
  return MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(_minLengthPassword,
        errorText: 'Password must be at least $_minLengthPassword digits long')
  ]);
}

MultiValidator emailValidator() {
  return MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);
}
