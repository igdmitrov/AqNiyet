import 'package:aqniyet/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return LookupFormInput(
      name: appLocalization.category,
      isLoading: isLoading,
      asyncItems: (String? filter) => appService.getCategories(filter: filter),
      onSaved: onSaved,
      validator: ModelValidator(errorText: appLocalization.category_required),
      selectedItem: selectedItem,
    );
  }
}
