import 'package:final_proj/authentication/signin.dart';
import 'package:final_proj/authentication/signup.dart';
import 'package:final_proj/screens/game.dart';
import 'package:final_proj/screens/home.dart';
import 'package:final_proj/screens/join_room.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Signin(),
      ),

      GoRoute(
        path: '/signup',
        builder: (context, state) => Signup(),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const Home(),
      ),

      GoRoute(
        path: '/game/:roomId',
        builder: (context, state) {
          final roomId = state.pathParameters['roomId'] ?? '';
          return Game(roomId: roomId);
        },
      ),

      GoRoute(
        path: '/join',
        builder: (context, state) => JoinRoom(),
      ),
      
    ]
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
