// for now i will make the chat row as a stateless widget!
import 'package:flutter/material.dart';

class ChatRow extends StatelessWidget {
  final String name, profilePic;
  final VoidCallback onTap;
  const ChatRow({
    super.key,
    required this.name,
    required this.profilePic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  // profilePic,
                  'assets/dummy_user.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
