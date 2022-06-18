import 'package:flutter/material.dart';

class TextFormInput extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool isLoading;
  const TextFormInput({Key? key, required this.name, required this.controller, this.validator, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: name),
      autocorrect: false,
      validator: validator,
      enabled: !isLoading,
    );
  }
}
