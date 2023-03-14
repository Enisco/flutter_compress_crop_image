import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  /// Upload image from gallery
  static Future<File?> getFromGallery() async {
    File? selectedImage;
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      var pickedImage = File(pickedFile.path);
      print('Current filepath: ${pickedFile.path}');
      var editedImage = await ImageHelper.compress(image: pickedImage);
      selectedImage = File(editedImage.path);
    }
    return selectedImage;
  }

  static Future<CroppedFile?> cropImage(File? imageFile) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.amber[800],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    return croppedFile;
  }

  static Future<File> compress({
    required File image,
    int quality = 100,
    int percentage = 50,
  }) async {
    const maxSizeAllowed = 1024.0;

    final sizeInKbBefore = image.lengthSync() / 1024;
    print('Before Compress: $sizeInKbBefore kb');

    if (sizeInKbBefore > maxSizeAllowed) {
      var compressedImageFile = await FlutterNativeImage.compressImage(
          image.absolute.path,
          quality: quality,
          percentage: percentage);
      double sizeInKbAfter = compressedImageFile.lengthSync() / 1024;
      print('After Compress: $sizeInKbAfter kb');

      while (sizeInKbAfter > maxSizeAllowed) {
        compressedImageFile = await FlutterNativeImage.compressImage(
          compressedImageFile.absolute.path,
          quality: quality,
          percentage: 80,
        );
        sizeInKbAfter = compressedImageFile.lengthSync() / 1024;
        print('After Compress again -> $sizeInKbAfter kb');
      }

      var croppedImage = await ImageHelper.cropImage(compressedImageFile);
      if (croppedImage == null) {
        return compressedImageFile;
      }
      compressedImageFile = File(croppedImage.path);

      return compressedImageFile;
    } else {
      var croppedImage = await ImageHelper.cropImage(image);
      if (croppedImage == null) {
        return image;
      }
      image = File(croppedImage.path);

      return image;
    }
  }
}
