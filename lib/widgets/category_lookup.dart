import 'package:aqniyet/services/app_service.dart';
import 'package:flutter/material.dart';

import '../components/model_validator.dart';
import '../model/category.dart';
import 'lookup_form_input.dart';

class CategoryLookup extends StatelessWidget {
  final bool isLoading;
  final AppService appService;
  final Function(Category?) onSaved;
  final Category? selectedItem;

  const CategoryLookup(
      {Key? key,
      required this.isLoading,
      required this.appService,
      required this.onSaved,
      this.selectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LookupFormInput(
      name: 'Category',
      isLoading: isLoading,
      asyncItems: (String? filter) => appService.getCategories(filter: filter),
      onSaved: onSaved,
      validator: ModelValidator(errorText: 'Category is required'),
      selectedItem: selectedItem,
    );
  }
}
