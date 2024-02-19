import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        profile_name = "Setup your Profile!";
      });
    } else {
      setState(() {
        profile_name = 'Hello, $admin!';
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
      profile_name = 'Hello,\n$adminName!';
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
                    profile_name,
                    style: TextStyle(
                      fontFamily: 'Monserrat',
                      fontSize: 48,
                      // fontWeight: FontWeight.w200,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Align(
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
                  child: Image.asset(
                    'assets/dummy_user.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 50, 8, 4),
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
                      // validator: _model.textController2Validator.asValidator(context), // Uncomment and integrate validator as needed
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
