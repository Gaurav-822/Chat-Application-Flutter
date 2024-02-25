import 'package:chat_app/Functions/firebase_message_api.dart';
import 'package:chat_app/Functions/profile_function.dart';
import 'package:chat_app/sprites/proflie_pic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonaPage extends StatefulWidget {
  const PersonaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PersonaPageState();
  }
}

class _PersonaPageState extends State<PersonaPage> {
  late String profileName = "";
  late TextEditingController _adminController;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _adminController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onLongPress: () {
              setState(() {
                pickAndUploadImage(profileName);
              });
            },
            child: ProfilePic(name: profileName),
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
                        _adminController.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                        sendNotification("title", "text",
                            "dPZVbxBNQFaZF_GsG5m_um:APA91bG8_z3Uqn1ZPoGW6Ifi3DxiPvjcpFCGDpHffmu2wiElKRW9VibKOhpIVDTa96ZBMRNOHyTBgyGUIThNMIi6-p7ts8vSl7mFQ0v51xqlOtnAM4hmhV5pyLc3aoXIRHCEcBOrotLJ");
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
