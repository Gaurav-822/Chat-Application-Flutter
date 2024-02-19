import 'package:chat_app/chats/conversation.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/chats_page.dart';
import 'package:chat_app/pages/friends_page.dart';
import 'package:chat_app/pages/persona_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => MyHomePage(
        title: "Gaurav",
      ),
    ),
    GoRoute(
        name: 'chats',
        path: '/chats/:name/:profilePic',
        builder: (context, state) {
          final name = state.pathParameters['name'] ?? "";
          final profilePic = state.pathParameters['profilePic'] ?? "";
          return Conversation(
            name: name,
            profilePic: profilePic,
          );
        }),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Shared Pref
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString("admin") == null) {
    prefs.setString("admin", "");
  }

  runApp(SplashApp());
}

class SplashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterSplashScreen(
        duration: const Duration(milliseconds: 2000),
        nextScreen: const MyApp(),
        backgroundColor: Colors.white,
        splashScreenBody: Center(
          child: Lottie.asset(
            "assets/splash_screen.json",
            repeat: false,
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(
              width: 8,
            ),
            // Image(
            //   image: AssetImage('assets/icon.jpg'),
            //   width: 50,
            //   height: 50,
            //   // minRadius: 25,
            //   // maxRadius: 25,
            // ),
            Text("Titly"),
          ],
        ),
      ),
      endDrawer: const Drawer(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 50, 0, 8),
          child: SingleChildScrollView(
            child: PersonaPage(),
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.transparent,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat),
                    SizedBox(width: 8.0),
                    Text('Chats'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 8.0),
                    Text('Friends'),
                  ],
                ),
              ),
              // Tab(
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(Icons.face),
              //       SizedBox(width: 8.0),
              //       Text('Persona'),
              //     ],
              //   ),
              // ),
            ],
            controller: _tabController,
            onTap: (index) => _pageController.jumpToPage(index),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              dragStartBehavior: DragStartBehavior.start,
              children: [
                Chats(),
                FriendsPage(),
                // Center(child: Text('Friends Page')),
                // PersonaPage(),
              ],
              onPageChanged: (index) {
                _tabController.index = index;
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
