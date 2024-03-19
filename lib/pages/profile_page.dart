import 'package:chat_app/Functions/image_functions.dart';
import 'package:chat_app/Functions/toasts.dart';
import 'package:chat_app/Functions/user/get_info.dart';
import 'package:chat_app/Functions/user/user.dart';
import 'package:chat_app/sprites/proflie_pic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  bool isVisible = false;
  bool _isLoading = false;
  late String profileName = "";
  late TextEditingController _profileNameController;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _profileNameController = TextEditingController();
    _loadProfileName();
  }

  _loadProfileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? admin = prefs.getString("admin");

    // String? uuid = getAdminUuid();
    if (admin == null) {
      String? uuid = getAdminUuid();
      // showToastMessage(uuid ?? "False UUID");
      String name = await getUserName(uuid!) ?? "Setup your Profile!";
      showToastMessage(name);
      setState(() {
        profileName = name;
      });
      _saveAdminName(profileName);
    } else {
      setState(() {
        profileName = admin;
        _profileNameController.text = profileName;
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
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _profileNameController.text = profileName;
                      toggleVisibility();
                      (isVisible)
                          ? showToastMessage("Edit")
                          : showToastMessage("Done");
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        (!isVisible) ? Icons.edit : Icons.done,
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '12',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '♡',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: _isLoading
                        ? Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CircularProgressIndicator(),
                          )
                        : (isVisible)
                            ? GestureDetector(
                                onTap: () {
                                  _showOptionsBottomSheet();
                                },
                                child: ProfilePic(
                                  name: profileName,
                                  zoom: false,
                                ),
                              )
                            : ProfilePic(
                                name: profileName,
                                zoom: true,
                              ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '69',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Friends',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            (isVisible)
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8.0),
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: _profileNameController,
                                  decoration: InputDecoration(
                                    labelText: "Enter your information",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Add your onPressed logic here
                                      userUpdateProfileName(
                                          _profileNameController.text);
                                      _saveAdminName(
                                          _profileNameController.text);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Change"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      profileName,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 64,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: null, // Allow the text to take up more lines
                    ),
                  )
                : Text(
                    profileName,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 64,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: null,
                  ),
            // ),
            Text(
              'soulgaurav08@gmail.com',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Memories',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  scrollDirection: Axis.vertical,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://picsum.photos/seed/702/600',
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://picsum.photos/seed/864/600',
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://picsum.photos/seed/8/600',
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://picsum.photos/seed/103/600',
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
