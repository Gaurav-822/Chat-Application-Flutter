import 'package:chat_app/Functions/profile_pic_funs.dart';
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
  late String profileName = "", code = "";
  late TextEditingController _adminController;

  late TextEditingController? _qrController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _qrController ??= TextEditingController(); // Initialize if null
    _adminController = TextEditingController();
    _loadProfileName();
    _loadQrCode();
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

  _loadQrCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? qrCode = prefs.getString("qrCode");

    if (qrCode == null || qrCode.isEmpty) {
      setState(() {
        code = profileName;
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
      profileName = adminName;
    });
  }

  _setQrCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("qrCode", code);
    setState(() {
      this.code = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
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
          GestureDetector(
            onLongPress: () {
              setState(() {
                pickAndUploadImage(profileName);
              });
            },
            child: ProfilePic(name: profileName),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 50, 8, 4),
                  child: TextFormField(
                    controller: _adminController,
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
                padding: const EdgeInsets.fromLTRB(8, 50, 8, 4),
                child: IconButton(
                  onPressed: () {
                    _saveAdminName(_adminController.text);
                    _adminController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  icon: const Icon(Icons.check),
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
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: TextFormField(
                    controller: _qrController,
                    autofocus: false,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: 'ID . . .',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _setQrCode(_qrController!.text);
                    });
                    _qrController!.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  icon: const Icon(Icons.check),
                  iconSize: 24,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
            child: Column(
              children: [
                const Text("Scan to add Friend"),
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
    );
  }
}
