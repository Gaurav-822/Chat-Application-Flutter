import 'package:shared_preferences/shared_preferences.dart';

loadProfileName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? admin = prefs.getString("admin");

  if (admin == null || admin.isEmpty) {
    return "Setup your Profile!";
  } else {
    return admin;
  }
}

saveAdminName(String adminName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("admin", adminName);
}

//streak