import 'package:chat_app/Functions/profile_function.dart';
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

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

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
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                (!isVisible)
                    ? GestureDetector(
                        onTap: () => toggleVisibility(),
                        child: const Align(
                          alignment: AlignmentDirectional(1, 0),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.edit,
                              size: 24,
                            ),
                          ),
                        ),
                      )
                    : const Align(
                        alignment: AlignmentDirectional(1, 0),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                            height: 24,
                          ),
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
                      Stack(
                        alignment: AlignmentDirectional(0, 0),
                        children: [
                          Align(
                            alignment: Alignment.center,
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
                          Visibility(
                            visible: isVisible,
                            child: GestureDetector(
                              onTap: () {
                                _showOptionsBottomSheet();
                              },
                              child: Icon(
                                Icons.edit,
                                size: 36,
                              ),
                            ),
                          ),
                        ],
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profileName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 64,
                      ),
                    ),
                    Visibility(
                      visible: isVisible,
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.edit,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
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
            Visibility(
              visible: isVisible,
              child: GestureDetector(
                onTap: () => toggleVisibility(),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Align(
                    alignment: AlignmentDirectional(0, 1),
                    child: Icon(
                      Icons.done,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
