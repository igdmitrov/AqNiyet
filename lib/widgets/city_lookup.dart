import 'package:aqniyet/services/app_service.dart';
import 'package:flutter/material.dart';

import '../components/model_validator.dart';
import '../model/city.dart';
import 'lookup_form_input.dart';

class CityLookup extends StatelessWidget {
  final bool isLoading;
  final AppService appService;
  final Function(City?) onSaved;
  final City? selectedItem;

  const CityLookup(
      {Key? key,
      required this.isLoading,
      required this.appService,
      required this.onSaved,
      this.selectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LookupFormInput(
      name: 'City',
      isLoading: isLoading,
      asyncItems: (String? filter) => appService.getCities(filter: filter),
      onSaved: onSaved,
      validator: ModelValidator(errorText: 'City is required'),
      selectedItem: selectedItem,
    );
  }
}
