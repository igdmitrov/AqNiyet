import 'package:aqniyet/components/advert_state.dart';
import 'package:aqniyet/widgets/text_form_input.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../components/model_validator.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../model/phonecode.dart';
import '../services/app_service.dart';
import '../widgets/category_lookup.dart';
import '../widgets/checkbox_form_input.dart';
import '../widgets/city_lookup.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/image_preview.dart';
import '../widgets/lookup_form_input.dart';
import '../widgets/phone_input.dart';
import '../widgets/phonecode_lookup.dart';
import '../widgets/remove_image_button.dart';
import '../widgets/text_area_input.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('New advert'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormInput(
                  name: 'Name',
                  controller: nameController,
                  isLoading: isLoading,
                  validator: RequiredValidator(errorText: 'Name is required'),
                ),
                const FormInputDivider(),
                CategoryLookup(
                    appService: appService,
                    isLoading: isLoading,
                    onSaved: (Category? val) => category = val),
                const FormInputDivider(),
                TextAreaInput(
                  name: 'Description',
                  controller: descriptionController,
                  validator:
                      RequiredValidator(errorText: 'Description is required'),
                  isLoading: isLoading,
                ),
                const FormInputDivider(),
                CityLookup(
                    appService: appService,
                    isLoading: isLoading,
                    onSaved: (City? val) => city = val),
                const FormInputDivider(),
                TextFormInput(
                  name: 'Address',
                  controller: addressController,
                  isLoading: isLoading,
                ),
                const FormInputDivider(),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PhonecodeLookup(
                        appService: appService,
                        isLoading: isLoading,
                        onSaved: (PhoneCode? val) => phoneCode = val,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                        child: PhoneInput(
                          controller: phoneController,
                          isLoading: isLoading,
                        ),
                      ),
                    ),
                  ],
                ),
                const FormInputDivider(),
                OutlinedButton(
                  onPressed: showOption,
                  child: const Text('Take a photo'),
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
                            ),
                          ],
                        )),
                  ],
                ),
                const FormInputDivider(),
                CheckboxFormInput(
                  title: 'Public',
                  onSaved: (val) => enabled = val ?? false,
                  enabled: !isLoading,
                  initialValue: true,
                ),
                const FormInputDivider(),
                ElevatedButton(
                    onPressed: isLoading ? null : saveData,
                    child: Text(isLoading ? 'Loading' : 'Save')),
                const FormInputDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
