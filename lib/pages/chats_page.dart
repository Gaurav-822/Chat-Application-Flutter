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
          onTap: () {
            GoRouter.of(context).go('/chats/Gaurav');
          },
        ),
        ChatRow(
          name: "Padmaja",
          onTap: () {
            GoRouter.of(context).go('/chats/Padmaja');
          },
        ),
        ChatRow(
          name: "Gugu",
          onTap: () {
            GoRouter.of(context).go('/chats/Gugu');
          },
        ),
      ],
    );
  }
}
