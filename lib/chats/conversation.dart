import 'dart:async';

import 'package:chat_app/message_bar.dart';
import 'package:chat_app/text_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Conversation extends StatefulWidget {
  final String name, profilePic;
  const Conversation({super.key, required this.name, required this.profilePic});

  @override
  State<StatefulWidget> createState() => _Conversation();
}

class _Conversation extends State<Conversation> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Stream<QuerySnapshot> receiverSenderStream;
  late Stream<QuerySnapshot> senderReceiverStream;

  late String admin;

  @override
  void initState() {
    super.initState();
    _loadProfileName();
    _initializeProfileAndStreams();
  }

  void _initializeProfileAndStreams() async {
    await _loadProfileName();

    // Now that admin is initialized, initialize streams
    senderReceiverStream = FirebaseFirestore.instance
        .collection('${admin}_${widget.name}')
        .orderBy('timestamp', descending: false)
        .snapshots();

    receiverSenderStream = FirebaseFirestore.instance
        .collection('${widget.name}_${admin}')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  _loadProfileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    admin = prefs.getString("admin")!;
  }

  final ScrollController _scrollController = ScrollController();

  void addData(String sender, receiver, message) {
    FieldValue time = FieldValue.serverTimestamp();
    FirebaseFirestore.instance.collection('${sender}_$receiver').add({
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': time,
    }).then((value) {
      print("User added");
    }).catchError((error) => print("Failed to add user: $error"));
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
              onTap: () {
                GoRouter.of(context).go('/');
              },
              child: const Icon(
                Icons.chevron_left,
              ),
            ),
            const SizedBox(width: 8),
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
