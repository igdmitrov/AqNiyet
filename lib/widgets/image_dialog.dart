import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ImageDialog extends StatelessWidget {
  final Uint8List image;
  const ImageDialog(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Image.memory(
        image,
        width: 90.w,
        height: 90.w,
        fit: BoxFit.cover,
      ),
    );
  }
}
