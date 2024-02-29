import 'package:chat_app/chats/conversation_page.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/signIn/login.dart';
import 'package:chat_app/signIn/signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

routes() {
  final GoRouter _router = GoRouter(
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
            path: 'chats/:name',
            builder: (BuildContext context, GoRouterState state) {
              final name = state.pathParameters['name'] ?? "";
              return ConversationPage(
                name: name,
              );
            },
          ),
          GoRoute(
            path: "profilePage",
            builder: (context, state) => ProfilePage(),
          )
        ],
      ),
      GoRoute(path: "/signin", builder: ((context, state) => const SignIn())),
      GoRoute(path: "/login", builder: ((context, state) => const LogIn())),
    ],
  );
  return _router;
}

authRoutes() {
  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: "/signin", builder: ((context, state) => const SignIn())),
      GoRoute(path: "/login", builder: ((context, state) => const LogIn())),
    ],
  );
  return _router;
}
