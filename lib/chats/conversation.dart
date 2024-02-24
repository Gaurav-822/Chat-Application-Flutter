import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/sprites/message_bar.dart';
import 'package:chat_app/sprites/text_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Conversation extends StatefulWidget {
  final String name;
  const Conversation({super.key, required this.name});

  @override
  State<StatefulWidget> createState() => _Conversation();
}

class _Conversation extends State<Conversation> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Stream<QuerySnapshot> receiverSenderStream;
  late Stream<QuerySnapshot> senderReceiverStream;

  late String admin;

  late String profile_name = "";

  @override
  void initState() {
    super.initState();
    _loadProfileName();
    _initializeProfileAndStreams();
  }

  Future<String?> getProfilePicUrl(String name) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('profile')
          .collection('admin')
          .where('name', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['url'] as String?;
      } else {
        print('No profile pic found for $name');
        return null;
      }
    } catch (error) {
      print('Error retrieving profile pic: $error');
      return null;
    }
  }

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

    senderReceiverStream = getMessagesStream(admin, widget.name);

    receiverSenderStream = getMessagesStream(admin, widget.name);
  }

  _loadProfileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    admin = prefs.getString("admin")!;
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
          return CircularProgressIndicator(); // or any loading indicator
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Once profile is loaded, build the UI
        return _buildConversation();
      },
    );
  }

  Widget _buildConversation() {
    String name = widget.name;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              child: Container(
                width: 30,
                height: 30,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: FutureBuilder<String?>(
                    future: getProfilePicUrl(profile_name),
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
                          child: Container(
                            // width: 120,
                            // height: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
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
                                                CircularProgressIndicator(), // Placeholder widget while loading
                                            errorWidget:
                                                (context, url, error) =>
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
                                    CircularProgressIndicator(), // Placeholder widget while loading
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/dummy_user.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
            const SizedBox(width: 4),
            Text(name),
          ],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: senderReceiverStream,
              builder: (context, senderSnapshot) {
                if (senderSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (senderSnapshot.hasError) {
                  return Center(child: Text('Error: ${senderSnapshot.error}'));
                }
                var senderDocuments = senderSnapshot.data?.docs ?? [];
                return StreamBuilder(
                  stream: receiverSenderStream,
                  builder: (context, receiverSnapshot) {
                    if (receiverSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (receiverSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${receiverSnapshot.error}'));
                    }
                    var receiverDocuments = receiverSnapshot.data?.docs ?? [];
                    var documents = [...senderDocuments, ...receiverDocuments];
                    documents.sort((a, b) {
                      final timestampA = a['timestamp'] as Timestamp?;
                      final timestampB = b['timestamp'] as Timestamp?;
                      if (timestampA == null && timestampB == null) {
                        return 0;
                      } else if (timestampA == null) {
                        return 1;
                      } else if (timestampB == null) {
                        return -1;
                      }
                      return timestampB.compareTo(timestampA);
                    });
                    return ListView.builder(
                      reverse: false,
                      controller: _scrollController,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        if (documents.isEmpty) {
                          return Container();
                        }
                        var messageData =
                            documents[documents.length - 1 - index].data()
                                as Map<String, dynamic>;
                        var message = messageData['message'] ?? '';
                        var sender = messageData['sender'] as String;
                        return TextBubble(
                          text: message,
                          orientation: sender == admin ? "right" : "left",
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          MessageBar(
            onMessageSent: (message) {
              setState(() {
                addData(admin, widget.name, message);
                scrollToListBottom();
              });
            },
          ),
        ],
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
