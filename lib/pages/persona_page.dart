import 'package:chat_app/Functions/profile_function.dart';
import 'package:chat_app/pages/profile_page.dart';
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
  late String profileName = "";
  final TextEditingController _adminController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

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
    return Padding(
      padding: EdgeInsets.all(8),
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
                  name: profileName,
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
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go('/profilePage');
                      },
                      child: Row(
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
                  alignment: AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      // onTap: About(),
                      child: Row(
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
                  alignment: AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      // onTap: () => Developer(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.settings,
                            color: Colors.grey, // Change to your desired color
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Settings',
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
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Log Out?"),
                              content: Text(
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
                      child: Row(
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

    // @override
    // Widget build(BuildContext context) {
    //   return SingleChildScrollView(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.max,
    //       children: [
    //         GestureDetector(
    //           onLongPress: () {
    //             _showOptionsBottomSheet();
    //           },
    //           child: _isLoading
    //               ? Container(
    //                   width: 120,
    //                   height: 120,
    //                   clipBehavior: Clip.antiAlias,
    //                   decoration: const BoxDecoration(
    //                     shape: BoxShape.circle,
    //                   ),
    //                   child: const CircularProgressIndicator(),
    //                 )
    //               : ProfilePic(name: profileName),
    //         ),
    //         Align(
    //           alignment: Alignment.centerLeft,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8),
    //             child: ShaderMask(
    //               blendMode: BlendMode.srcIn,
    //               shaderCallback: (Rect bounds) {
    //                 return const LinearGradient(
    //                   colors: <Color>[Colors.red, Colors.blue],
    //                 ).createShader(bounds);
    //               },
    //               child: Center(
    //                 child: Text(
    //                   "Hello, $profileName!",
    //                   style: const TextStyle(
    //                     fontFamily: 'amatic',
    //                     fontSize: 48,
    //                     fontWeight: FontWeight.w500,
    //                     letterSpacing: 1.5,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
    //           child: Column(
    //             children: [
    //               const Center(
    //                 child: Text(
    //                   "Update",
    //                   style: TextStyle(
    //                     // letterSpacing: 1.5,
    //                     fontFamily: 'Readex Pro',
    //                     fontSize: 36,
    //                     fontWeight: FontWeight.w200,
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 8,
    //               ),
    //               Row(
    //                 mainAxisSize: MainAxisSize.max,
    //                 children: [
    //                   Expanded(
    //                     child: TextFormField(
    //                       controller: _adminController,
    //                       autofocus: false,
    //                       obscureText: false,
    //                       decoration: const InputDecoration(
    //                         hintText: 'Name:',
    //                         enabledBorder: InputBorder.none,
    //                         focusedBorder: InputBorder.none,
    //                         errorBorder: InputBorder.none,
    //                         focusedErrorBorder: InputBorder.none,
    //                       ),
    //                     ),
    //                   ),
    //                   IconButton(
    //                     onPressed: () {
    //                       _saveAdminName(_adminController.text);
    //                       addUserNameAndFCMToken(_adminController.text);
    //                       updateApiToken(_adminController.text);
    //                       _adminController.clear();
    //                       FocusManager.instance.primaryFocus?.unfocus();
    //                     },
    //                     icon: const Icon(Icons.check),
    //                     iconSize: 24,
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         ElevatedButton(
    //             onPressed: () {
    //               signOut();
    //             },
    //             child: const Text("Log Out")),
    //         Divider(
    //           thickness: 1,
    //           indent: 16,
    //           endIndent: 16,
    //           color: Colors.black.withOpacity(0.08), // Adjust opacity as needed
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(8),
    //           child: Column(
    //             children: [
    //               const Text("Scan to add as a Friend"),
    //               QrImageView(
    //                 data: profileName,
    //                 version: QrVersions.auto,
    //                 size: 200.0,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
  }
}
