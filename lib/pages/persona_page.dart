import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class PersonaPage extends StatefulWidget {
  const PersonaPage({Key? key});

  @override
  State<StatefulWidget> createState() {
    return _PersonaPageState();
  }
}

class _PersonaPageState extends State<PersonaPage> {
  late String profile_name = "", code = ""; // Initialize with a default value
  late TextEditingController _adminController;

  late TextEditingController? _qrController = TextEditingController();

  String? _imageUrl;
  final _picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _qrController ??= TextEditingController(); // Initialize if null
    _adminController = TextEditingController();
    _loadProfileName();
    _loadQrCode();
  }

  Future<void> _saveImageToLocal(File image) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagePath = '${appDir.path}/image.png';
    await image.copy(imagePath);
    print('Image saved locally: $imagePath');
  }

  void addProfilePic(String name, String url) {
    FirebaseFirestore.instance
        .collection('users')
        .doc("profile")
        .collection("admin")
        .where('name', isEqualTo: name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // If a document with the same name exists, update its URL
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({'url': url}).then((_) {
            print("Profile pic for $name updated");
            setState(() {
              getProfilePicUrl(name);
            });
          }).catchError((error) {
            print("Failed to update profile pic: $error");
          });
        });
      } else {
        // If no document with the same name exists, add a new document
        FirebaseFirestore.instance
            .collection('users')
            .doc("profile")
            .collection("admin")
            .add({
          'name': name,
          'url': url,
        }).then((DocumentReference docRef) {
          print("Profile pic for $name added @: ${docRef.id}");
          setState(() {
            getProfilePicUrl(name);
          });
        }).catchError((error) {
          print("Failed to add profile pic: $error");
        });
      }
    }).catchError((error) {
      print("Error fetching document: $error");
    });
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageRef =
            FirebaseStorage.instance.ref().child('images/$profile_name.jpg');
        await imageRef.putFile(File(pickedFile.path));
        _imageUrl = await imageRef.getDownloadURL();

        setState(() {
          addProfilePic(profile_name, _imageUrl!);
        });
      }
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors (e.g., storage full)
      print('Firebase error: $e');
    } catch (e) {
      // Handle other exceptions (e.g., permissions)
      print('Other error: $e');
    }
  }

  Future<String?> getProfilePicUrl(String name) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('profile')
          .collection('admin')
          .where('name', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['url'] as String?;
      } else {
        print('No profile pic found for $name');
        return null;
      }
    } catch (error) {
      print('Error retrieving profile pic: $error');
      return null;
    }
  }

  _loadProfileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? admin = prefs.getString("admin");

    if (admin == null || admin.isEmpty) {
      setState(() {
        profile_name = "Setup your Profile!";
      });
    } else {
      setState(() {
        profile_name = admin;
      });
    }
  }

  _loadQrCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? qrCode = prefs.getString("qrCode");

    if (qrCode == null || qrCode.isEmpty) {
      setState(() {
        code = "https://youtu.be/8PTOkwze0Vw?si=kwkYmszP7-eMuPU7";
      });
    } else {
      setState(() {
        code = qrCode;
      });
    }
  }

  _saveAdminName(String adminName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("admin", adminName);
    setState(() {
      profile_name = adminName;
    });
  }

  _setQrCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("qrCode", code);
    setState(() {
      this.code = code; // Update the code variable of the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: <Color>[Colors.red, Colors.blue],
                    ).createShader(bounds);
                  },
                  child: Text(
                    "Hello, $profile_name!",
                    style: TextStyle(
                      fontFamily: 'amatic',
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            FutureBuilder<String?>(
                future: getProfilePicUrl(profile_name),
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Data has been successfully retrieved
                    String? imageUrl = snapshot.data;
                    return Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                        child: Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _pickAndUploadImage();
                            },
                            child: CachedNetworkImage(
                              imageUrl: imageUrl ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(), // Placeholder widget while loading
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/dummy_user.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 50, 8, 4),
                    child: TextFormField(
                      controller: _adminController,
                      maxLength: 10,
                      autofocus: false,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: 'Name: . . .',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 50, 8, 4),
                  child: IconButton(
                    onPressed: () {
                      _saveAdminName(_adminController.text);
                      _adminController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: Icon(Icons.check),
                    iconSize: 24,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
                    child: TextFormField(
                      controller: _qrController,
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: 'ID . . .',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      // style: TextStyle(), // You can apply custom styling here if needed
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _setQrCode(_qrController!.text);
                      });
                      _qrController!.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: Icon(Icons.check),
                    iconSize: 24,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
              child: Column(
                children: [
                  Text("Scan to add Friend"),
                  QrImageView(
                    data: code,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
