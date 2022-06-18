import 'image_data.dart';

class ImageMetaData {
  final String id;
  final String imageName;
  final String advertId;
  final bool primary;
  final String createdBy;

  ImageMetaData({
    required this.id,
    required this.imageName,
    required this.advertId,
    required this.primary,
    required this.createdBy,
  });

  factory ImageMetaData.fromJson(Map<String, dynamic> json) {
    return ImageMetaData(
      id: json['id'],
      imageName: json['image_name'],
      advertId: json['advert_id'],
      primary: json['primary'],
      createdBy: json['created_by'],
    );
  }

  factory ImageMetaData.fromImageData(ImageData imageData, bool primary) {
    return ImageMetaData(
      id: imageData.id,
      imageName: imageData.imageName,
      advertId: imageData.advertId,
      primary: primary,
      createdBy: imageData.createdBy,
    );
  }

  Map toMap() {
    return {
      'image_name': imageName,
      'advert_id': advertId,
      'primary': primary,
      'created_by': createdBy,
    };
  }
}
