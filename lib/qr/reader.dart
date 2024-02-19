import 'package:flutter/material.dart';

class Reader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Reader();
}

class _Reader extends State<Reader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Center(
        child: Text("data"),
      ),
    );
  }
}
