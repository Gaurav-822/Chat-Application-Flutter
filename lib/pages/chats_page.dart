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
    return (chatNames.isNotEmpty)
        ? ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: chatNames.length,
            itemBuilder: (BuildContext context, int index) {
              final String name = chatNames[index][0];
              final String uuid = chatNames[index][1];
              // return Dismissible(
              //   key: Key(uuid), // Unique key for each item
              //   direction: DismissDirection.startToEnd,
              //   confirmDismiss: (DismissDirection direction) async {
              //     return await showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           title: Text("Confirm"),
              //           content: Text("Are you sure you want to delete $name?"),
              //           actions: <Widget>[
              //             TextButton(
              //               onPressed: () => Navigator.of(context).pop(true),
              //               child: Text("DELETE"),
              //             ),
              //             TextButton(
              //               onPressed: () => Navigator.of(context).pop(false),
              //               child: Text("CANCEL"),
              //             ),
              //           ],
              //         );
              //       },
              //     );
              //   },
              //   onDismissed: (direction) {
              //     // Remove the item from the list when dismissed
              //     setState(() {
              //       chatNames.removeAt(index);
              //       updateMessagedToNo(uuid);
              //     });
              //   },
              //   background: Container(
              //     color: Colors.red, // Background color when swiping to delete
              //     alignment: Alignment.centerRight,
              //     child: const Padding(
              //       padding: EdgeInsets.only(right: 20.0),
              //       child: Icon(
              //         Icons.delete,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ), child:
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
                  onTap: () {
                    GoRouter.of(context).go('/chats/$name/$uuid');
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
