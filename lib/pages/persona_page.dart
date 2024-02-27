import 'package:chat_app/Functions/profile_function.dart';
import 'package:chat_app/sprites/proflie_pic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonaPage extends StatefulWidget {
  const PersonaPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PersonaPageState();
  }
}

class _PersonaPageState extends State<PersonaPage> {
  late String profileName = "";
  final TextEditingController _adminController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

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
        profileName = "Setup your Profile!";
      });
    } else {
      setState(() {
        profileName = admin;
      });
    }
  }

  _saveAdminName(String adminName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("admin", adminName);
    setState(() {
      profileName = adminName;
    });
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                setState(() {
                  _isLoading = true;
                });
                await pickAndUploadImage(profileName, false);
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Media'),
              onTap: () {
                Navigator.pop(context);
                pickAndUploadImage(profileName, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onLongPress: () {
              _showOptionsBottomSheet();
            },
            child: _isLoading
                ? Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const CircularProgressIndicator(),
                  )
                : ProfilePic(name: profileName),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: <Color>[Colors.red, Colors.blue],
                  ).createShader(bounds);
                },
                child: Center(
                  child: Text(
                    "Hello, $profileName!",
                    style: const TextStyle(
                      fontFamily: 'amatic',
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Update",
                    style: TextStyle(
                      // letterSpacing: 1.5,
                      fontFamily: 'Readex Pro',
                      fontSize: 36,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _adminController,
                        autofocus: false,
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: 'Name:',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _saveAdminName(_adminController.text);
                        updateApiToken(_adminController.text);
                        _adminController.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      icon: const Icon(Icons.check),
                      iconSize: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.black.withOpacity(0.08), // Adjust opacity as needed
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Text("Scan to add as a Friend"),
                QrImageView(
                  data: profileName,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
