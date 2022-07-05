import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/advert_state.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../services/app_service.dart';
import '../widgets/category_lookup.dart';
import '../widgets/checkbox_form_input.dart';
import '../widgets/city_lookup.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/image_preview.dart';
import '../widgets/remove_image_button.dart';
import '../widgets/text_area_input.dart';
import '../widgets/text_form_input.dart';

class AddPage extends StatefulWidget {
  static String routeName = '/add';
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends AdvertState<AddPage> {
  @override
  Widget build(BuildContext context) {
    final appService = context.read<AppService>();
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalization.new_advert),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormInput(
                  name: appLocalization.name,
                  controller: nameController,
                  isLoading: isLoading,
                  validator: RequiredValidator(
                      errorText: appLocalization.name_required),
                ),
                const FormInputDivider(),
                CategoryLookup(
                    appService: appService,
                    isLoading: isLoading,
                    onSaved: (Category? val) => category = val),
                const FormInputDivider(),
                TextAreaInput(
                  name: appLocalization.description,
                  controller: descriptionController,
                  validator: RequiredValidator(
                      errorText: appLocalization.description_required),
                  isLoading: isLoading,
                ),
                const FormInputDivider(),
                CityLookup(
                    appService: appService,
                    isLoading: isLoading,
                    onSaved: (City? val) => city = val),
                const FormInputDivider(),
                TextFormInput(
                  name: appLocalization.address,
                  controller: addressController,
                  isLoading: isLoading,
                ),
                const FormInputDivider(),
                if (canAttachImage())
                  OutlinedButton(
                    onPressed: () => showOption(appLocalization),
                    child: Text(appLocalization.take_photo),
                  ),
                const FormInputDivider(),
                Wrap(
                  children: [
                    ...images.map((image) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    mainImageId = image.name;
                                  });
                                },
                                child: ImagePreview(
                                  file: image,
                                  primary: mainImageId == image.name,
                                ),
                              ),
                            ),
                            RemoveImageButton(
                              onPressed: () =>
                                  removeImageFromMemory(image.name),
                              isLoading: isLoading,
                            ),
                          ],
                        )),
                  ],
                ),
                const FormInputDivider(),
                CheckboxFormInput(
                  title: appLocalization.public,
                  onSaved: (val) => enabled = val ?? false,
                  enabled: !isLoading,
                  initialValue: true,
                ),
                const FormInputDivider(),
                ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => saveData(appLocalization, appService),
                    child: Text(isLoading
                        ? appLocalization.loading
                        : appLocalization.save)),
                const FormInputDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
