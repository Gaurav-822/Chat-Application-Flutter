import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveChatName(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> chatNames = prefs.getStringList('chatNames') ?? [];

  // Remove the existing occurrence of the name (if any)
  chatNames.remove(name);

  // Add the name to the beginning of the list
  chatNames.insert(0, name);

  // Save the updated list to shared preferences
  await prefs.setStringList('chatNames', chatNames);
}
