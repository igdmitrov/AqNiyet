import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/advert.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../model/image_data.dart';
import '../model/image_meta_data.dart';
import '../pages/main_page.dart';
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
            await _saveImage(appService, advertId, image);

            if (image.name == mainImageId) {
              await _savePrimaryIcon(appService, advertId, image.name);
            }
          }

          if (!mounted) return;
          context.showSnackBar(message: appLocalizations.created_new_item);
          Navigator.of(context).pop();
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
            await _saveImage(appService, id, image);
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
                await _savePrimaryIcon(appService, id, imageData.imageName);
              }
            }
          }

          if (!mounted) return;
          Navigator.of(context).pop();
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  File _resizeImage(String filePath, String saveToPath, int imageWidth) {
    final image = img.decodeImage(File(filePath).readAsBytesSync());
    if (image == null) return File(filePath);

    if (image.width > imageWidth) {
      final resized = img.copyResize(image, width: imageWidth);
      File(saveToPath).writeAsBytesSync(img.encodeJpg(resized));
    }

    return File(saveToPath);
  }

  Uint8List _resizeImageBinary(Uint8List data, int imageWidth) {
    Uint8List resizedData = data;
    img.Image image = img.decodeImage(data) as img.Image;
    img.Image resized = img.copyResize(image, width: imageWidth);
    resizedData = Uint8List.fromList(img.encodeJpg(resized));
    return resizedData;
  }

  Future<void> _saveImage(
      AppService appService, String advertId, XFile file) async {
    final response = await appService.saveImage(getCurrentUserId(), advertId,
        file.name, _resizeImage(file.path, file.path, maxImageWidth));

    final error = response.error;
    if (response.hasError) {
      if (!mounted) return;
      context.showErrorSnackBar(message: error!.message);
    } else {
      await _saveImageMetaData(appService, advertId, file.name);
    }
  }

  Future<void> _savePrimaryIcon(
      AppService appService, String advertId, String fileNameFrom) async {
    final originFile = await appService.downloadImage(
      ImageMetaData(
        id: '',
        imageName: fileNameFrom,
        advertId: advertId,
        primary: true,
        createdBy: getCurrentUserId(),
      ),
    );

    if (originFile == null) return;

    await appService.removeImage(getCurrentUserId(), advertId, iconFileName);

    final response = await appService.saveImageBinary(
        getCurrentUserId(),
        advertId,
        iconFileName,
        _resizeImageBinary(originFile, maxImageIconWidth));

    final error = response.error;
    if (response.hasError) {
      if (!mounted) return;
      context.showErrorSnackBar(message: error!.message);
    }
  }

  Future<void> _saveImageMetaData(
      AppService appService, String advertId, String fileName) async {
    final response = await appService.addImageMetaData(ImageMetaData(
      id: '',
      advertId: advertId,
      primary: fileName == mainImageId ? true : false,
      imageName: fileName,
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
      await appService.removeImageMetaData(imageData.id);
      await appService.removeImage(
          imageData.createdBy, imageData.advertId, imageData.imageName);

      if (imageData.primary == true) {
        final imagesMetaDataItems =
            await appService.getImages(imageData.advertId, getCurrentUserId());

        if (imagesMetaDataItems.isNotEmpty) {
          final nextImage = imagesMetaDataItems.first;
          await appService
              .setPrimaryImage(ImageMetaData.fromImageData(nextImage, true));
          await _savePrimaryIcon(
              appService, imageData.advertId, nextImage.imageName);

          mainLocalImageId = nextImage.imageName;
        } else if (images.isNotEmpty) {
          mainLocalImageId = images.first.name;
        } else {
          mainLocalImageId = null;
          await appService.removeImage(
              imageData.createdBy, imageData.advertId, iconFileName);
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

    final response = await appService.removeAdvert(getCurrentUserId(), id);
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
