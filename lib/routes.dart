import 'package:chat_app/Functions/user/get_info.dart';
import 'package:chat_app/chats/conversation_page.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/pages/about/about_page.dart';
import 'package:chat_app/pages/gallery/for_admin.dart';
import 'package:chat_app/pages/gallery/for_love.dart';
import 'package:chat_app/pages/profile/profile_page.dart';
import 'package:chat_app/signIn/login.dart';
import 'package:chat_app/signIn/signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

routes() {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const MyHomePage(
          title: "Titly",
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'chats/:receiverName/:receiverUuid',
            builder: (BuildContext context, GoRouterState state) {
              final receiverUuid = state.pathParameters['receiverUuid'] ?? "";
              final receiverName = state.pathParameters['receiverName'] ?? "";

              // Define variables for sender and receiver names
              String senderName = "None";
              String senderUuid = "None";
              // String receiverName = "None";

              Future<void> loadProfileNames() async {
                senderUuid = await getAdminLocally();
                senderName = await getUserName(senderUuid) ?? "None";
                // receiverName = await getUserName(receiverUuid) ?? "None";
              }

              // Call the async function immediately
              loadProfileNames();

              // Return ConversationPage with sender and receiver names
              return FutureBuilder(
                future: loadProfileNames(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ConversationPage(
                      senderUuid: senderUuid,
                      receiverUuid: receiverUuid,
                      senderName: senderName,
                      receiverName: receiverName,
                    );
                  } else {
                    // Return a loading indicator while loading profile names
                    return Center(
                      child: Lottie.asset(
                        "assets/lotties/loading.json",
                        repeat: true,
                        frameRate: const FrameRate(144),
                      ),
                    );
                  }
                },
              );
            },
          ),
          GoRoute(
            path: "profilePage",
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: "aboutPage",
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            path: "galleryForLove",
            builder: (context, state) => const GalleryForLoved(),
          ),
          GoRoute(
            path: "galleryForAdmin",
            builder: (context, state) => const GalleryForAdmin(),
          ),
        ],
      ),
      GoRoute(path: "/signin", builder: ((context, state) => const SignIn())),
      GoRoute(path: "/login", builder: ((context, state) => const LogIn())),
    ],
  );
  return router;
}

authRoutes() {
  final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: "/signin", builder: ((context, state) => const SignIn())),
      GoRoute(path: "/login", builder: ((context, state) => const LogIn())),
    ],
  );
  return router;
}
