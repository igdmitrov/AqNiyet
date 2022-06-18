import 'dart:typed_data';

import 'image_meta_data.dart';

class ImageData {
  final String id;
  final String imageName;
  final String advertId;
  final bool primary;
  final String createdBy;
  final Uint8List image;

  ImageData({
    required this.id,
    required this.imageName,
    required this.advertId,
    required this.primary,
    required this.createdBy,
    required this.image,
  });

  factory ImageData.fromMetaData(ImageMetaData metaData, Uint8List image) {
    return ImageData(
      id: metaData.id,
      imageName: metaData.imageName,
      advertId: metaData.advertId,
      primary: metaData.primary,
      createdBy: metaData.createdBy,
      image: image,
    );
  }
}
