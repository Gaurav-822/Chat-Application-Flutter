import 'package:chat_app/main.dart';
import 'package:chat_app/routes.dart';
import 'package:chat_app/signIn/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user logged in
            if (snapshot.hasData) {
              return const SplashApp();
            }
            // user not logged in
            else {
              return MaterialApp.router(
                routerConfig: authRoutes(),
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
              );
            }
          },
        ),
      ),
    );
  }
}
