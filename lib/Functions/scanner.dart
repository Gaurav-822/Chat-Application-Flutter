import 'package:chat_app/Functions/user/friends.dart';
import 'package:chat_app/Functions/toasts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> friends = [];

Future scanQRCode() async {
  String? scanResult;

  try {
    scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.DEFAULT);
    // Add the checks for adding friends
  } catch (e) {
    scanResult = null;
  }

  if (scanResult == null || scanResult == '-1') {
    // Return early if scanResult is null, empty, or widget is not mounted
    // Or if scanResult is '-1' indicating that scanning operation was canceled
    showToastMessage("Scan not successful, Retry");
    return;
  }

  if (!scanResult.startsWith("Titly/")) {
    showToastMessage("Not a Titly Tag");
    return;
  }

  scanResult = scanResult.split("/")[1];
  // add this data to the cloud
  addFriend(scanResult);

  updateFriendsDataToList(scanResult);
  showToastMessage("$scanResult is now a friend");

  return scanResult;
}

updateFriendsDataToList(String newFriend) async {
  // get prev list
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? existingFriends = prefs.getStringList('friends');
  existingFriends ??= [];

  //add new friend
  existingFriends.add(newFriend);
  await prefs.setStringList('friends', existingFriends);
}
