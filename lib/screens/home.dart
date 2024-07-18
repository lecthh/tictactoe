import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/services/auth_service.dart';
import 'package:final_proj/utils/app_colors.dart';
import 'package:final_proj/utils/helper.dart';
import 'package:final_proj/utils/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final authService = AuthService();
    String? fetchedUsername = await authService.getUsername();
    setState(() {
      username = fetchedUsername;
    });
  }

  void _startGame() async {
    String roomId = generateRoomId();
    await FirebaseFirestore.instance.collection('gameRooms').doc(roomId).set({
      'roomId': roomId,
      'player1': username,
      'player2': '',
      'board': List.filled(9, 0),
      'turn': 1,
      'createdAt': FieldValue.serverTimestamp()
    });
    await FirebaseFirestore.instance.collection('gameRooms').doc(roomId).collection('messages').doc('init').set({});
    // ignore: use_build_context_synchronously
    context.go('/game/$roomId');
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBlack,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "tic tac toe",
                  style: GoogleFonts.shareTech(
                    textStyle: const TextStyle(
                      color: kGreen,
                      fontSize: 32,
                    ),
                  ),
                ),
                Text(
                  "welcome, ${username ?? '...'}",
                  style: GoogleFonts.shareTech(
                    textStyle: const TextStyle(
                      color: kYellow,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                GestureDetector(
                  onTap: _startGame,
                  child: const PrimaryButton(text: "start game", color: kPink, isStatic: true)
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    context.go('/join');
                  },
                  child: const PrimaryButton(text: "join room", color: kGreen, isStatic: true)
                ),
              ],
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () async {
                final authService = AuthService();
                await authService.signOut();
                // ignore: use_build_context_synchronously
                context.go('/');
              },
              child: Text(
                "log out",
                style: GoogleFonts.shareTech(
                  fontSize: 16,
                  color: kYellow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
