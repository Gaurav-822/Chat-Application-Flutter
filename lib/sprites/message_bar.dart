import 'package:flutter/material.dart';

class MessageBar extends StatefulWidget {
  final Function(String) onMessageSent;

  const MessageBar({
    Key? key,
    required this.onMessageSent,
  }) : super(key: key);

  @override
  MessageBarState createState() => MessageBarState();
}

class MessageBarState extends State<MessageBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
              child: TextFormField(
                controller: _controller,
                autofocus: false,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
                maxLines: 5,
                minLines: 1,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send_rounded,
              size: 24,
            ),
            onPressed: () {
              final message = _controller.text.trim();
              _controller.clear();
              if (message.isNotEmpty) {
                widget.onMessageSent(message);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
