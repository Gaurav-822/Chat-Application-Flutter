import 'package:shared_preferences/shared_preferences.dart';

loadProfileName() async {
  String profileName;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? admin = prefs.getString("admin");

  if (admin == null || admin.isEmpty) {
    profileName = "Setup your Profile!";
  } else {
    profileName = admin;
  }

  return profileName;
}

saveAdminName(String adminName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("admin", adminName);
  return adminName;
}
