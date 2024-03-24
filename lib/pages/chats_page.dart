import 'package:chat_app/Functions/user/friends.dart';
import 'package:chat_app/chats/chat_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return (chatNames.isEmpty)
        ? FutureBuilder<void>(
            future: _loadChatNames(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while data is being fetched
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Handle error case
                return Center(
                  child: Text('Error loading data'),
                );
              } else {
                // Data loaded successfully, show the list
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount: chatNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String name = chatNames[index][0];
                    final String uuid = chatNames[index][1];
                    return ChatRow(
                      name: name,
                      onTap: () {
                        GoRouter.of(context).go('/chats/$uuid/$name');
                      },
                    );
                  },
                );
              }
            },
          )
        : ListView.builder(
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
          );
  }
}
