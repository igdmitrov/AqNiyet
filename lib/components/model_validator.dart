import 'package:form_field_validator/form_field_validator.dart';

class ModelValidator extends FieldValidator<Object?> {
  ModelValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(Object? value) {
    return value == null ? false : true;
  }
}
