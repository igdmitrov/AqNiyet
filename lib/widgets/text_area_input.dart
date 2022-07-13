import 'package:flutter/material.dart';

class TextAreaInput extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final bool isLoading;
  final FormFieldValidator<String>? validator;
  const TextAreaInput(
      {Key? key,
      required this.isLoading,
      required this.controller,
      this.validator,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: name),
      autocorrect: false,
      validator: validator,
      enabled: !isLoading,
      minLines: 3,
      maxLines: 5,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
    );
  }
}
