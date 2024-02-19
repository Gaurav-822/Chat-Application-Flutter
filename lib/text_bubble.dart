import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final String text, orientation;
  // final VoidCallback onPressed;

  const TextBubble({Key? key, required this.text, required this.orientation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orientation.toLowerCase() == "right") {
      return Align(
        alignment: const AlignmentDirectional(0.95, 0),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(100, 0, 5, 0),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                text,
              ),
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: const AlignmentDirectional(-0.95, 0),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 100, 0),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(0),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                text,
              ),
            ),
          ),
        ),
      );
    }
  }
}
