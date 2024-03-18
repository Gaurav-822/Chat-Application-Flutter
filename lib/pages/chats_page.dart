import 'package:chat_app/chats/chat_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<String> chatNames = [];

  @override
  void initState() {
    super.initState();
    _loadChatNames();
    _saveChatName("Gaurav");
    _saveChatName("Padmaja");
    _saveChatName("Papu");
    _saveChatName("Anu Shaitan");
    _saveChatName("Mummy");
  }

  Future<void> _loadChatNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedChatNames = prefs.getStringList('chatNames') ?? [];
    setState(() {
      chatNames = storedChatNames;
    });
  }

  Future<void> _saveChatName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!chatNames.contains(name)) {
      // Check if the name is not already in the list
      chatNames.add(name); // Add the new name to the list
      await prefs.setStringList('chatNames',
          chatNames); // Save the updated list to shared preferences
      setState(() {}); // Trigger a rebuild to reflect the changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return (chatNames.length == 0)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/lotties/send_messages_lottie.json",
                repeat: true,
                frameRate: const FrameRate(144),
              ),
              // Text(
              //   "Start Connecting ❦",
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              // ),
              GestureDetector(
                onTap: () {
                  // Change Tab
                },
                child: const Icon(
                  Icons.chevron_right_rounded,
                  size: 50,
                ),
              ),
            ],
          )
        : ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: chatNames.length,
            itemBuilder: (BuildContext context, int index) {
              final String name = chatNames[index];
              return ChatRow(
                name: name,
                onTap: () {
                  GoRouter.of(context).go('/chats/$name');
                },
              );
            },
          );
  }
}
