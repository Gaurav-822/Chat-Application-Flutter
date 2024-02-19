import 'package:chat_app/chats/chat_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<StatefulWidget> createState() => _Chats();
}

class _Chats extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      children: [
        ChatRow(
          name: "Gaurav",
          profilePic: "https://picsum.photos/seed/657/600",
          onTap: () {
            GoRouter.of(context).go('/chats/Gaurav/1');
          },
        ),
        ChatRow(
          name: "Padmaja",
          profilePic: "https://picsum.photos/seed/657/600",
          onTap: () {
            GoRouter.of(context).go('/chats/Padmaja/1');
          },
        ),
        ChatRow(
          name: "Gugu",
          profilePic: "https://picsum.photos/seed/657/600",
          onTap: () {
            GoRouter.of(context).go('/chats/Gugu/1');
          },
        ),
      ],
    );
  }
}
