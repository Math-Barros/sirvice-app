import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCropperService {
  Future<File?> pickImage({required File image, required CropStyle style, CropAspectRatio? ratio}) async {
    var imageCropper = ImageCropper(); // Cria uma instância de ImageCropper
    var croppedFile = await imageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 2000,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      aspectRatio: ratio,
      cropStyle: style,
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }
}
