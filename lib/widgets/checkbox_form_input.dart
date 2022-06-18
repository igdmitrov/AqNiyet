import 'package:flutter/material.dart';

class CheckboxFormInput extends FormField<bool> {
  CheckboxFormInput(
      {Key? key,
      required String title,
      required FormFieldSetter<bool> onSaved,
      FormFieldValidator<bool>? validator,
      required bool enabled,
      bool initialValue = false,
      autoValidate = false})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            enabled: enabled,
            builder: (FormFieldState<bool> state) {
              return CheckboxListTile(
                  dense: state.hasError,
                  value: state.value,
                  onChanged: state.didChange,
                  title: Text(title),
                  controlAffinity: ListTileControlAffinity.leading,
                  subtitle: state.hasError
                      ? Builder(
                          builder: (BuildContext context) => Text(
                              state.errorText as String,
                              style: TextStyle(
                                  color: Theme.of(context).errorColor)))
                      : null);
            });
}
