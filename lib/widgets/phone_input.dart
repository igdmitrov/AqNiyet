import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../utils/constants.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;

  const PhoneInput(
      {Key? key, required this.controller, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Phone'),
      autocorrect: false,
      validator: RequiredValidator(errorText: 'Phone is required'),
      enabled: !isLoading,
      keyboardType: TextInputType.phone,
      inputFormatters: [phoneMaskFormatter],
    );
  }
}
