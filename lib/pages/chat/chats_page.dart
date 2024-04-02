import 'package:chat_app/Functions/user/friends.dart';
import 'package:chat_app/chats/chat_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class Chats extends StatefulWidget {
  final List<List<String>> chatNames;
  const Chats({super.key, required this.chatNames});

  @override
  State<StatefulWidget> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> chatNames = widget.chatNames;
    // sort according to the time stamps
    chatNames = sortNestedList(chatNames);
    return (chatNames.isNotEmpty)
        ? ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: chatNames.length,
            itemBuilder: (BuildContext context, int index) {
              final String name = chatNames[index][0];
              final String uuid = chatNames[index][1];
              return GestureDetector(
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Wrap(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              name,
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Delete'),
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                chatNames.removeAt(index);
                                updateMessagedToNo(uuid);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ChatRow(
                  name: name,
                  uuid: uuid,
                  onTap: () {
                    GoRouter.of(context).go('/chats/$name/$uuid');
                    updateFriends(uuid);
                  },
                ),
              );
              // );
            },
          )
        : Center(
            child: Lottie.asset(
              "assets/lotties/send_messages_lottie.json",
              repeat: false,
              frameRate: const FrameRate(144),
            ),
          );
  }
}
