import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../model/base_model.dart';

class LookupFormInput<T extends BaseModel> extends StatelessWidget {
  final String name;
  final bool isLoading;
  final DropdownSearchOnFind<T> asyncItems;
  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T> onSaved;
  final T? selectedItem;

  const LookupFormInput(
      {Key? key,
      required this.name,
      required this.isLoading,
      this.validator,
      required this.asyncItems,
      required this.onSaved,
      this.selectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      key: ValueKey(name.toLowerCase()),
      popupProps:
          const PopupProps.dialog(isFilterOnline: true, showSearchBox: true),
      enabled: !isLoading,
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(labelText: name)),
      itemAsString: (T? model) => model!.value(),
      asyncItems: asyncItems,
      dropdownBuilder: (ctx, T? model) =>
          model == null ? const Text('') : Text(model.value()),
      onSaved: onSaved,
      validator: validator,
      selectedItem: selectedItem,
    );
  }
}
