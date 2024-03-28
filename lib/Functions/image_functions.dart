import 'dart:io';

import 'package:chat_app/Functions/toasts.dart';
import 'package:chat_app/Functions/user/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickAndUploadImage(profileName, bool gallery) async {
  final picker = ImagePicker();
  String? imageUrl;
  try {
    final pickedFile = (gallery)
        ? await picker.pickImage(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Crop the picked image
      final croppedFile = await _cropImage(imageFile: File(pickedFile.path));

      showToastMessage("Profile pic setting for $profileName");

      if (croppedFile != null) {
        final imageRef =
            FirebaseStorage.instance.ref().child('images/$profileName.jpg');
        await imageRef.putFile(croppedFile);
        imageUrl = await imageRef.getDownloadURL();

        userUpdateProfileImageURL(imageUrl);
      }
    }
  } on FirebaseException catch (e) {
    debugPrint('Firebase error: $e');
  } catch (e) {
    debugPrint('Other error: $e');
  }
}

Future<File?> _cropImage({required File imageFile}) async {
  CroppedFile? croppedImage =
      await ImageCropper().cropImage(sourcePath: imageFile.path);
  if (croppedImage == null) return null;
  return File(croppedImage.path);
}
