import 'package:chat_app/Functions/user/friends.dart';
import 'package:chat_app/chats/chat_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<List<String>> chatNames = [];

  @override
  void initState() {
    super.initState();
    _loadChatNames();
  }

  Future<void> _loadChatNames() async {
    List<List<String>> temp = await getNestedDataForChat();
    setState(() {
      chatNames = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (chatNames.isNotEmpty)
        ? ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: chatNames.length,
            itemBuilder: (BuildContext context, int index) {
              final String name = chatNames[index][0];
              final String uuid = chatNames[index][1];
              return ChatRow(
                name: name,
                onTap: () {
                  GoRouter.of(context).go('/chats/$name/$uuid');
                },
              );
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
