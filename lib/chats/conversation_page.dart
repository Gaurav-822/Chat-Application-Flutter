import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Functions/user/get_info.dart';
import 'package:chat_app/chats/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final String senderUuid, receiverUuid, senderName, receiverName;
  const ConversationPage({
    super.key,
    required this.senderUuid,
    required this.receiverUuid,
    required this.senderName,
    required this.receiverName,
  });

  @override
  State<StatefulWidget> createState() => _ConversationPage();
}

class _ConversationPage extends State<ConversationPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Stream<QuerySnapshot> receiverSenderStream;
  late Stream<QuerySnapshot> senderReceiverStream;

  @override
  void initState() {
    super.initState();
    _initializeProfileAndStreams();
  }

  void _initializeProfileAndStreams() async {
    // Now that admin is initialized, initialize streams
    Stream<QuerySnapshot> getMessagesStream(String sender, receiver) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc('messages')
          .collection('${sender}_$receiver')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }

    senderReceiverStream =
        getMessagesStream(widget.senderUuid, widget.receiverUuid);

    receiverSenderStream =
        getMessagesStream(widget.senderUuid, widget.receiverUuid);
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
    }).catchError((error) => throw ("Failed to add message: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return _buildConversationPage();
  }

  Widget _buildConversationPage() {
    String receiverUuid = widget.receiverUuid;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              child: Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: FutureBuilder<String?>(
                    future: getUserImageUrl(receiverUuid),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show a loading screen while the data is being fetched
                        return const CircularProgressIndicator();
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
            Text(widget.receiverName),
          ],
        ),
      ),
      body: Conversation(
        adminUuid: widget.senderUuid,
        receiverUuid: widget.receiverUuid,
        adminName: widget.senderName,
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
