import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../components/advert_state.dart';
import '../components/model_validator.dart';
import '../model/advert_page_view.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../model/image_data.dart';
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
import '../widgets/text_form_input.dart';

class EditPage extends StatefulWidget {
  static String routeName = '/edit';
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends AdvertState<EditPage> {
  @override
  Widget build(BuildContext context) {
    final advert = ModalRoute.of(context)!.settings.arguments as AdvertPageView;
    nameController.text = advert.name;
    descriptionController.text = advert.description;
    addressController.text = advert.address;
    phoneController.text = advert.phone;
    enabled = advert.enabled;

    final appService = context.read<AppService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(advert.name),
        automaticallyImplyLeading: false,
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
                FutureBuilder<Category>(
                    future: appService.getCategoryById(advert.categoryId),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        return CategoryLookup(
                            appService: appService,
                            isLoading: isLoading,
                            onSaved: (Category? val) => category = val,
                            selectedItem: snapshot.data);
                      }
                      return const Text('Loading');
                    }),
                const FormInputDivider(),
                TextAreaInput(
                  name: 'Description',
                  controller: descriptionController,
                  validator:
                      RequiredValidator(errorText: 'Description is required'),
                  isLoading: isLoading,
                ),
                const FormInputDivider(),
                FutureBuilder<City>(
                    future: appService.getCityById(advert.cityId),
                    builder: (ctx, snapshot) {
                      return CityLookup(
                        appService: appService,
                        isLoading: isLoading,
                        onSaved: (City? val) => city = val,
                        selectedItem: snapshot.data,
                      );
                    }),
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
                      child: FutureBuilder<PhoneCode>(
                          future:
                              appService.getPhoneCodeById(advert.phoneCodeId),
                          builder: (ctx, snapshot) {
                            return PhonecodeLookup(
                              appService: appService,
                              isLoading: isLoading,
                              onSaved: (PhoneCode? val) => phoneCode = val,
                              selectedItem: snapshot.data,
                            );
                          }),
                    ),
                    Expanded(
                      flex: 4,
                      child: PhoneInput(
                        controller: phoneController,
                        isLoading: isLoading,
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
                FutureBuilder<List<ImageData>>(
                  future: appService.getImages(advert.id, advert.createdBy),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(
                        children: [
                          ...snapshot.data!.map(
                            (imageData) {
                              if (removedImages.any(
                                      (element) => imageData.id == element) ==
                                  false) {
                                if (imageData.primary && mainImageId == null) {
                                  mainImageId = imageData.imageName;
                                }

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            mainImageId = imageData.imageName;
                                          });
                                        },
                                        child: ImagePreview(
                                          data: imageData.image,
                                          primary: (imageData.primary == true &&
                                                  mainImageId == null) ||
                                              mainImageId ==
                                                  imageData.imageName,
                                        ),
                                      ),
                                    ),
                                    RemoveImageButton(
                                      onPressed: () =>
                                          removeImage(imageData, appService),
                                    ),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      );
                    }

                    return const Text('Loading');
                  },
                ),
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
                  initialValue: enabled,
                ),
                const FormInputDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => updateData(advert.id, appService),
                        child: Text(isLoading ? 'Loading' : 'Save')),
                    const SizedBox(width: 10),
                    OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back')),
                  ],
                ),
                const FormInputDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
