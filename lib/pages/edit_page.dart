import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/advert_state.dart';
import '../model/advert_page_view.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../model/image_data.dart';
import '../services/app_service.dart';
import '../widgets/category_lookup.dart';
import '../widgets/checkbox_form_input.dart';
import '../widgets/city_lookup.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/image_preview.dart';
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
    enabled = advert.enabled;

    final appService = context.read<AppService>();
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

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
                  name: appLocalization.name,
                  controller: nameController,
                  isLoading: isLoading,
                  validator: RequiredValidator(
                      errorText: appLocalization.name_required),
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
                      return Text(appLocalization.loading);
                    }),
                const FormInputDivider(),
                TextAreaInput(
                  name: appLocalization.description,
                  controller: descriptionController,
                  validator: RequiredValidator(
                      errorText: appLocalization.description_required),
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
                  name: appLocalization.address,
                  controller: addressController,
                  isLoading: isLoading,
                ),
                const FormInputDivider(),
                FutureBuilder(
                    future:
                        appService.getImageCount(advert.id, advert.createdBy),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        final savedImages = (snapshot.data! as int);
                        if (canAttachImage(savedImages: savedImages)) {
                          return OutlinedButton(
                            onPressed: () => showOption(appLocalization),
                            child: Text(appLocalization.take_photo),
                          );
                        } else {
                          return Container();
                        }
                      }

                      return Text(appLocalization.loading);
                    }),
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
                                      onPressed: () => removeImage(imageData,
                                          appService, appLocalization),
                                      isLoading: isLoading,
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

                    return Text(appLocalization.loading);
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
                        child: Text(isLoading
                            ? appLocalization.loading
                            : appLocalization.save)),
                    const SizedBox(width: 10),
                    OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(appLocalization.back)),
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
