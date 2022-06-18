import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ImagePreview extends StatelessWidget {
  final bool primary;
  final XFile? file;
  final Uint8List? data;
  const ImagePreview({Key? key, required this.primary, this.file, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        if (file != null)
          Image.file(
            File(file!.path),
            width: 45.w,
            height: 45.w,
            fit: BoxFit.cover,
          ),
        if (data != null)
          Image.memory(
            data!,
            width: 45.w,
            height: 45.w,
            fit: BoxFit.cover,
          ),
        if (primary == true)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Main image',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                background: Paint()..color = Colors.green,
              ),
            ),
          ),
      ],
    );
  }
}
