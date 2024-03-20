import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Functions/toasts.dart';
import 'package:chat_app/Functions/user/get_info.dart';
import 'package:chat_app/chats/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationPage extends StatefulWidget {
  final String uuid;
  const ConversationPage({super.key, required this.uuid});

  @override
  State<StatefulWidget> createState() => _ConversationPage();
}

class _ConversationPage extends State<ConversationPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Stream<QuerySnapshot> receiverSenderStream;
  late Stream<QuerySnapshot> senderReceiverStream;

  late String adminUuid, reciever_name;

  @override
  void initState() {
    super.initState();
    _loadProfileName();
    _initializeProfileAndStreams();
  }

  // Future<String?> getProfilePicUrl(String name) async {
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc('profile')
  //         .collection('admin')
  //         .where('name', isEqualTo: name)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       return querySnapshot.docs.first.data()['url'] as String?;
  //     } else {
  //       print('No profile pic found for $name');
  //       return null;
  //     }
  //   } catch (error) {
  //     print('Error retrieving profile pic: $error');
  //     return null;
  //   }
  // }

  void _initializeProfileAndStreams() async {
    await _loadProfileName();

    // Now that admin is initialized, initialize streams
    Stream<QuerySnapshot> getMessagesStream(String sender, receiver) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc('messages')
          .collection('${sender}_$receiver')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }

    senderReceiverStream = getMessagesStream(adminUuid, widget.uuid);

    receiverSenderStream = getMessagesStream(adminUuid, widget.uuid);
  }

  _loadProfileName() async {
    String admin = await getAdminLocally();
    adminUuid = admin;

    String r_name = await getUserName(widget.uuid) ?? "None";
    // showToastMessage(widget.uuid);
    reciever_name = r_name;
  }

  final ScrollController _scrollController = ScrollController();

  void addData(String sender, receiver, message) {
    String documentId = "${sender}_${receiver}";
    FirebaseFirestore.instance
        .collection('users')
        .doc("messages")
        .collection(documentId)
        .add({
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((DocumentReference docRef) {
      print("Message added with ID: ${docRef.id}");
    }).catchError((error) => print("Failed to add message: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadProfileName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or any loading indicator
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Once profile is loaded, build the UI
        return _buildConversationPage();
      },
    );
  }

  Widget _buildConversationPage() {
    String uuid = widget.uuid;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              child: Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: FutureBuilder<String?>(
                    future: getUserImageUrl(uuid),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show a loading screen while the data is being fetched
                        return CircularProgressIndicator();
                        // );
                      } else if (snapshot.hasError) {
                        // Show an error message if there's an error
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Data has been successfully retrieved
                        String? imageUrl = snapshot.data;
                        return Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            16), // Adjust the radius according to your preference
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl ?? '',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(), // Placeholder widget while loading
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            "assets/dummy_user.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: CachedNetworkImage(
                              imageUrl: imageUrl ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/dummy_user.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
            const SizedBox(width: 4),
            Text(reciever_name),
          ],
        ),
      ),
      body: Conversation(
        admin_uuid: adminUuid,
        receiver_uuid: widget.uuid,
      ),
    );
  }

  void scrollToListBottom() {
    // Check if already at the bottom
    if (_scrollController.position.pixels !=
        _scrollController.position.maxScrollExtent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 50), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(
                milliseconds: 300), // Decrease duration for smoother scrolling
            curve: Curves.easeInOut, // Use a smoother curve
          );
        });
      });
    }
  }
}
