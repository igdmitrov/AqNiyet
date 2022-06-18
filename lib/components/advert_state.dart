import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../model/advert.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../model/image_data.dart';
import '../model/image_meta_data.dart';
import '../model/phonecode.dart';
import '../pages/my_adverts_page.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';
import 'auth_required_state.dart';

class AdvertState<T extends StatefulWidget> extends AuthRequiredState<T> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool enabled = true;
  Category? category;
  City? city;
  PhoneCode? phoneCode;
  final List<XFile> images = [];
  String? mainImageId;
  List<String> removedImages = [];

  Future<void> saveData() async {
    setState(() {
      isLoading = true;
    });

    if (formKey.currentState != null &&
        formKey.currentState!.validate() &&
        isAuthenticated()) {
      formKey.currentState!.save();

      if (category != null && city != null && phoneCode != null) {
        final model = Advert(
          id: '',
          categoryId: category!.id,
          name: nameController.text,
          description: descriptionController.text,
          cityId: city!.id,
          address: addressController.text,
          phoneCodeId: phoneCode!.id,
          phone: phoneController.text,
          enabled: enabled,
          createdBy: getCurrentUserId(),
        );

        final response = await context.read<AppService>().createAdvert(model);
        final error = response.error;
        if (response.hasError) {
          context.showErrorSnackBar(message: error!.message);
        } else {
          final advertId =
              (((response.data) as List<dynamic>)[0]['id']) as String;

          for (var image in images) {
            await _saveImage(advertId, image);
          }

          context.showSnackBar(message: 'You created a new item');
          Navigator.of(context).pushReplacementNamed(MyAdvertsPages.routeName);
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateData(String id, AppService appService) async {
    setState(() {
      isLoading = true;
    });

    if (formKey.currentState != null &&
        formKey.currentState!.validate() &&
        isAuthenticated()) {
      formKey.currentState!.save();

      if (category != null && city != null && phoneCode != null) {
        final model = Advert(
          id: id,
          categoryId: category!.id,
          name: nameController.text,
          description: descriptionController.text,
          cityId: city!.id,
          address: addressController.text,
          phoneCodeId: phoneCode!.id,
          phone: phoneController.text,
          enabled: enabled,
          createdBy: getCurrentUserId(),
        );

        final response = await appService.updateAdvert(model);
        final error = response.error;
        if (response.hasError) {
          context.showErrorSnackBar(message: error!.message);
        } else {
          for (var image in images) {
            await _saveImage(id, image);
          }

          if (mainImageId != null) {
            final imageDataList =
                await appService.getImages(id, getCurrentUserId());

            for (var imageData in imageDataList) {
              if (imageData.primary == true &&
                  mainImageId != imageData.imageName) {
                await appService.setPrimaryImage(
                    ImageMetaData.fromImageData(imageData, false));
              }

              if (mainImageId == imageData.imageName) {
                await appService.setPrimaryImage(
                    ImageMetaData.fromImageData(imageData, true));
              }
            }
          }

          Navigator.of(context).pushReplacementNamed(MyAdvertsPages.routeName);
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveImage(String advertId, XFile file) async {
    final response = await supabase.storage.from('public-images').upload(
        '${getCurrentUserId()}/$advertId/${file.name}', File(file.path));

    final error = response.error;
    if (response.hasError) {
      context.showErrorSnackBar(message: error!.message);
    } else {
      await _saveImageMetaData(advertId, file);
    }
  }

  Future<void> _saveImageMetaData(String advertId, XFile file) async {
    final response =
        await context.read<AppService>().addImageMetaData(ImageMetaData(
              id: '',
              advertId: advertId,
              primary: file.name == mainImageId ? true : false,
              imageName: file.name,
              createdBy: getCurrentUserId(),
            ));
    final error = response.error;
    if (response.hasError) {
      context.showErrorSnackBar(message: error!.message);
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? pickedPhoto =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedPhoto != null) {
        setState(() {
          images.add(pickedPhoto);

          mainImageId ??= pickedPhoto.name;
        });
      }
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error');
    }
  }

  Future<void> _getImagesFromGallery() async {
    try {
      final List<XFile>? pickedPhotos = await _picker.pickMultiImage();

      if (pickedPhotos != null) {
        setState(() {
          images.addAll(pickedPhotos);

          mainImageId ??= pickedPhotos[0].name;
        });
      }
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error');
    }
  }

  Future<void> showOption() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _getImagesFromGallery();
              },
              child: const Text('Gallery')),
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _takePicture();
              },
              child: const Text('Camera')),
        ],
      ),
    );
  }

  Future<void> removeImage(ImageData imageData, AppService appService) async {
    setState(() {
      isLoading = true;
    });

    String? mainLocalImageId = mainImageId;

    try {
      await appService.removeImage(imageData.id);

      if (imageData.primary == true) {
        final imagesMetaDataItems =
            await appService.getImages(imageData.advertId, getCurrentUserId());

        if (imagesMetaDataItems.isNotEmpty) {
          await appService.setPrimaryImage(
              ImageMetaData.fromImageData(imagesMetaDataItems.first, true));

          mainLocalImageId = imagesMetaDataItems.first.imageName;
        } else if (images.isNotEmpty) {
          mainLocalImageId = images.first.name;
        } else {
          mainLocalImageId = null;
        }
      }
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error');
    }

    setState(() {
      removedImages.add(imageData.id);
      mainImageId = mainLocalImageId;
      isLoading = false;
    });
  }

  void removeImageFromMemory(String imageId) async {
    setState(() {
      images.remove(images.firstWhere((element) => element.name == imageId));

      if (mainImageId == imageId) {
        if (images.isNotEmpty) {
          mainImageId = images.first.name;
        } else {
          mainImageId = null;
        }
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
