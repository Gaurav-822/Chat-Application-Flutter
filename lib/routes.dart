import 'package:chat_app/chats/conversation.dart';
import 'package:chat_app/main.dart';
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
              return Conversation(
                name: name,
              );
            },
          ),
        ],
      ),
    ],
  );
  return _router;
}
