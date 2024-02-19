import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      // Simulate loading data for 3 seconds as the splash screen duration
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show the splash screen while waiting for the Future to complete
          return AnimatedSplashScreen(
            splash: Column(
              children: [
                Center(
                  child: Lottie.asset(
                    "assets/splash_screen.json",
                    repeat: false,
                  ),
                )
              ],
            ),
            nextScreen: const MyApp(),
            splashIconSize: 400,
            // Modify the duration as per your requirement
            duration: 3000, // Show splash screen for 3 seconds
          );
        } else {
          // Once the splash screen duration is over, navigate to '/home' route
          GoRouter.of(context).go('/home');
          // Return an empty container while navigating to prevent rendering anything on the screen
          return Container();
        }
      },
    );
  }
}
