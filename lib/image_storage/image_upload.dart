import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUpload extends StatefulWidget {
  final String id;

  ImageUpload({super.key, required this.id});
  @override
  State<StatefulWidget> createState() {
    return _ImageUpload();
  }
}

class _ImageUpload extends State<ImageUpload> {
  String? _imageUrl;
  late String profile_name;
  final _picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _loadProfileName();
  }

  _loadProfileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? admin = prefs.getString("admin");

    if (admin == null || admin.isEmpty) {
      setState(() {
        profile_name = "None";
      });
    } else {
      setState(() {
        profile_name = admin;
      });
    }
  }

  void addProfilePic(String name, url) {
    FirebaseFirestore.instance
        .collection('users')
        .doc("profile")
        .collection("admin")
        .add({
      'name': name,
      'url': url,
    }).then((DocumentReference docRef) {
      print("Profile pic saved @: ${docRef.id}");
    }).catchError((error) => print("Failed to Save Profile Pic: $error"));
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageRef =
            FirebaseStorage.instance.ref().child('images/${widget.id}.jpg');
        await imageRef.putFile(File(pickedFile.path));
        _imageUrl = await imageRef.getDownloadURL();

        setState(() {
          addProfilePic(profile_name, _imageUrl);
        });
      }
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors (e.g., storage full)
      print('Firebase error: $e');
    } catch (e) {
      // Handle other exceptions (e.g., permissions)
      print('Other error: $e');
    }
    GoRouter.of(context).go('/persona');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload and Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20.0),
            _imageUrl != null
                ? Image.network(_imageUrl!)
                : const Text('No image selected'),
          ],
        ),
      ),
    );
  }
}
