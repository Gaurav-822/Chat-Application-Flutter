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
  late String uuid;

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
    _loadUuid();
  }

  _loadUuid() async {
    String getUuid = await getAdminLocally();
    uuid = getUuid;
  }

  _loadProfileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? admin = prefs.getString("adminName");

    if (admin == null) {
      String? uuid = getAdminUuid();
      String name = await getUserName(uuid!) ?? "Setup your Profile!";
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
    prefs.setString("adminName", adminName);
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
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Profile Page",
            style: TextStyle(
              fontFamily: "title_font",
              letterSpacing: 1.5,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // showToastMessage(uuid);
              _profileNameController.text = profileName;
              toggleVisibility();
              // (isVisible) ? showToastMessage("Edit") : showToastMessage("Done");
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                (!isVisible) ? Icons.edit : Icons.done,
                size: 24,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.centerLeft,
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
                  : (isVisible)
                      ? GestureDetector(
                          onTap: () {
                            _showOptionsBottomSheet();
                          },
                          child: ProfilePic(
                            uuid: uuid,
                            zoom: false,
                          ),
                        )
                      : ProfilePic(
                          uuid: uuid,
                          zoom: true,
                        ),
            ),
            (isVisible)
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Row(
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
                                const SizedBox(height: 16.0),
                                TextFormField(
                                  controller: _profileNameController,
                                  decoration: const InputDecoration(
                                    labelText: "Enter your information",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          (profileName != "None") ? profileName : "Set Name",
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 48,
                          ),
                          textAlign: TextAlign.center,
                          maxLines:
                              null, // Allow the text to take up more lines
                        ),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        (profileName != "None") ? profileName : "Set Name",
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 48,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: null, // Allow the text to take up more lines
                      ),
                    ),
                  ),
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      uuid,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 50,
                      child: VerticalDivider(
                        thickness: 1,
                        indent: 4,
                        endIndent: 4,
                        // color: Colors.black, // Use your preferred color
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '4',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '♡',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '1',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Friends',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-1, 0),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Memories',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .merge(const TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 24,
                      )),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  scrollDirection: Axis.vertical,
                  children: const [
                    Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(0),
                          ),
                          child: Text("Coming!")),
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
