import 'package:chat_app/Functions/image_functions.dart';
import 'package:chat_app/Functions/scanner.dart';
import 'package:chat_app/Functions/toasts.dart';
import 'package:chat_app/Functions/user/get_info.dart';
import 'package:chat_app/signIn/auth/email_pass_auth.dart';
import 'package:chat_app/sprites/proflie_pic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonaPage extends StatefulWidget {
  const PersonaPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PersonaPageState();
  }
}

class _PersonaPageState extends State<PersonaPage> {
  late String profileName = "", uuid;
  final TextEditingController adminController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileName();
    _loadUuid();
  }

  _loadUuid() async {
    String getUuid = await getAdminLocally();
    uuid = getUuid;
  }

  void closeEndDrawer(BuildContext context) {
    Navigator.of(context).pop();
  }

  _loadProfileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? admin = prefs.getString("adminName");

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

  void showBottomOptionBar() {
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
                  isLoading = true;
                });
                await pickAndUploadImage(profileName, false);
                setState(() {
                  isLoading = false;
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: ProfilePic(
                  uuid: uuid,
                  zoom: true,
                ),
              ),
              // ProfilePic(name: profileName),
              const SizedBox(
                height: 150,
                child: VerticalDivider(
                  thickness: 1,
                ),
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: <Color>[
                            Color.fromARGB(255, 255, 145, 0),
                            Color.fromARGB(255, 174, 157, 0)
                          ],
                        ).createShader(bounds);
                      },
                      child: Center(
                        child: Text(
                          "Hello,\n$profileName!",
                          style: const TextStyle(
                            fontFamily: 'amatic',
                            fontSize: 48,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: const AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        closeEndDrawer(context);
                        GoRouter.of(context).go('/profilePage');
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Colors.grey, // Change to your desired color
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 24,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.grey, // Change to your desired color
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 24,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () => GoRouter.of(context).go('/aboutPage'),
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.grey, // Change to your desired color
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'About',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 24,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: const AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        scanQRCode();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.qr_code,
                            color: Colors.grey, // Change to your desired color
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Add Friend',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 24,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      QrImageView(
                        data: "Titly/${getAdminUuid()}",
                        version: QrVersions.auto,
                        size: 175.0,
                      ),
                      const Text("Scan to add as a Friend"),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 16,
                // ),
                Align(
                  alignment: const AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Log Out?"),
                              content: const Text(
                                  "Do you want to log out from this account"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    signOut();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Yes"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("No"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.logout,
                            color: Colors.grey, // Change to your desired color
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Log Out',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 24,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
