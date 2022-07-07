import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/advert.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../model/image_data.dart';
import '../model/image_meta_data.dart';
import '../pages/main_page.dart';
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
  final ImagePicker _picker = ImagePicker();
  bool enabled = true;
  bool confirm = false;
  Category? category;
  City? city;
  final List<XFile> images = [];
  String? mainImageId;
  List<String> removedImages = [];

  int getImageCount() {
    return images.length;
  }

  bool canAttachImage({int savedImages = 0}) {
    return (getImageCount() + savedImages) < maxImages;
  }

  Future<void> saveData(
      AppLocalizations appLocalizations, AppService appService) async {
    setState(() {
      isLoading = true;
    });

    if (formKey.currentState != null &&
        formKey.currentState!.validate() &&
        isAuthenticated()) {
      formKey.currentState!.save();

      if (confirm == false) {
        context.showErrorSnackBar(
            message: appLocalizations.unconfirmed_privacy);
      }

      if (category != null && city != null && confirm == true) {
        final model = Advert(
          id: '',
          categoryId: category!.id,
          name: nameController.text,
          description: descriptionController.text,
          cityId: city!.id,
          address: addressController.text,
          phone: getCurrentUserPhone(),
          enabled: enabled,
          createdBy: getCurrentUserId(),
        );

        final response = await appService.createAdvert(model);
        final error = response.error;
        if (response.hasError) {
          if (!mounted) return;
          context.showErrorSnackBar(message: error!.message);
        } else {
          final advertId =
              (((response.data) as List<dynamic>)[0]['id']) as String;

          for (var image in images) {
            await _saveImage(advertId, image);
          }

          if (!mounted) return;
          context.showSnackBar(message: appLocalizations.created_new_item);
          Navigator.of(context).pushReplacementNamed(MyAdvertsPages.routeName);
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateData(String id, AppLocalizations appLocalizations,
      AppService appService) async {
    setState(() {
      isLoading = true;
    });

    if (formKey.currentState != null &&
        formKey.currentState!.validate() &&
        isAuthenticated()) {
      formKey.currentState!.save();

      if (confirm == false) {
        context.showErrorSnackBar(
            message: appLocalizations.unconfirmed_privacy);
      }

      if (category != null && city != null && confirm == true) {
        final model = Advert(
          id: id,
          categoryId: category!.id,
          name: nameController.text,
          description: descriptionController.text,
          cityId: city!.id,
          address: addressController.text,
          phone: getCurrentUserPhone(),
          enabled: enabled,
          createdBy: getCurrentUserId(),
        );

        final response = await appService.updateAdvert(model);
        final error = response.error;
        if (response.hasError) {
          if (!mounted) return;
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

          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed(MyAdvertsPages.routeName);
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  File _resizeImage(String filePath) {
    final image = decodeImage(File(filePath).readAsBytesSync());
    if (image == null) return File(filePath);

    if (image.width > maxImageWidth) {
      final thumbnail = copyResize(image, width: maxImageWidth);
      File(filePath).writeAsBytesSync(encodePng(thumbnail));
    }

    return File(filePath);
  }

  Future<void> _saveImage(String advertId, XFile file) async {
    final response = await supabase.storage.from('public-images').upload(
        '${getCurrentUserId()}/$advertId/${file.name}',
        _resizeImage(file.path));

    final error = response.error;
    if (response.hasError) {
      if (!mounted) return;
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
      if (!mounted) return;
      context.showErrorSnackBar(message: error!.message);
    }
  }

  Future<void> _takePicture(AppLocalizations appLocalization) async {
    try {
      final XFile? pickedPhoto =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedPhoto != null && canAttachImage()) {
        setState(() {
          images.add(pickedPhoto);

          mainImageId ??= pickedPhoto.name;
        });
      }
    } catch (error) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }
  }

  Future<void> _getImagesFromGallery(AppLocalizations appLocalization) async {
    try {
      final List<XFile>? pickedPhotos = await _picker.pickMultiImage();

      if (pickedPhotos != null && canAttachImage()) {
        setState(() {
          images.addAll((pickedPhotos.length + getImageCount()) > maxImages
              ? pickedPhotos.take(maxImages - getImageCount())
              : pickedPhotos);

          mainImageId ??= pickedPhotos[0].name;
        });
      }
    } catch (error) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }
  }

  Future<void> showOption(AppLocalizations appLocalization) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _getImagesFromGallery(appLocalization);
              },
              child: Text(appLocalization.gallery)),
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _takePicture(appLocalization);
              },
              child: Text(appLocalization.camera)),
        ],
      ),
    );
  }

  Future<void> removeImage(ImageData imageData, AppService appService,
      AppLocalizations appLocalization) async {
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
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
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

  Future<void> removeItem(AppService appService, String id) async {
    setState(() {
      isLoading = true;
    });

    final response = await appService.removeAdvert(id);
    final error = response.error;
    if (response.hasError) {
      if (!mounted) return;
      context.showErrorSnackBar(message: error!.message);
    }

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil(MainPage.routeName, (route) => false);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
