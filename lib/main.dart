import 'package:chat_app/Functions/firebase_message_api.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/auth_page.dart';
import 'package:chat_app/pages/chats_page.dart';
import 'package:chat_app/pages/friends_page.dart';
import 'package:chat_app/pages/persona_page.dart';
import 'package:chat_app/routes.dart';
import 'package:chat_app/signIn/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  await precacheLottie('assets/splash_screen.json');

  runApp(const AuthPage());
}

Future<void> precacheLottie(String assetPath) async {
  await rootBundle.load(assetPath);
}

class SplashApp extends StatelessWidget {
  const SplashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      home: FlutterSplashScreen(
        duration: const Duration(milliseconds: 1800),
        nextScreen: const MyApp(),
        backgroundColor: const Color(0xFFE0E0E0),
        splashScreenBody: Center(
          child: Lottie.asset(
            "assets/splash_screen.json",
            repeat: false,
            frameRate: const FrameRate(144),
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
    return MaterialApp.router(
      routerConfig: routes(),
      theme: ThemeData.light().copyWith(
        // Light theme
        tabBarTheme: const TabBarTheme(
          labelColor:
              Color.fromARGB(255, 230, 180, 0), // Your desired tab label color
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        // iconTheme: IconThemeData(
        //   color: Colors.white, // Your desired icon color for light theme
        // ),
        // Dark theme
        tabBarTheme: TabBarTheme(
          labelColor: Colors.yellow
              .withOpacity(0.8), // Your desired tab label color for dark theme
        ),
      ),
    );
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
    askNoti();
    _tabController = TabController(length: 2, vsync: this);
  }

  void askNoti() async {
    await FirebaseMessageApi().initNotification();
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
            Text(
              "Titly",
              style: TextStyle(
                fontFamily: "title_font",
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      endDrawer: const Drawer(
        elevation: 24,
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: SingleChildScrollView(
              child: PersonaPage(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.transparent,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat),
                    SizedBox(width: 8.0),
                    Text(
                      'Chats',
                      style: TextStyle(
                        fontFamily: "teko",
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 8.0),
                    Text(
                      'Friends',
                      style: TextStyle(
                        fontFamily: "teko",
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            controller: _tabController,
            onTap: (index) => _pageController.jumpToPage(index),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              dragStartBehavior: DragStartBehavior.start,
              children: const [
                Chats(),
                FriendsPage(),
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
