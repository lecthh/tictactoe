import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/services/auth_service.dart';
import 'package:final_proj/utils/app_colors.dart';
import 'package:final_proj/utils/primary_button.dart';
import 'package:final_proj/utils/textbox.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class JoinRoom extends StatelessWidget {
  JoinRoom({super.key});

  final authService = AuthService();
  TextEditingController gameIdController = TextEditingController();


  Future<void> joinRandomGame(BuildContext context) async {
    String? username = await authService.getUsername();
    if (username == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to retrieve username. Please try again.'),
        ),
      );
      return;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('gameRooms')
      .where('player2', isEqualTo: '')
      .limit(1)
      .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot gameRoom = querySnapshot.docs.first;

      await FirebaseFirestore.instance
        .collection('gameRooms')
        .doc(gameRoom.id)
        .update({'player2': username});

      // ignore: use_build_context_synchronously
      context.go('/game/${gameRoom.id}');
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available game rooms found.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBlack,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "join room",
              style: GoogleFonts.shareTech(
                textStyle: const TextStyle(
                  color: kGreen,
                  fontSize: 32
                )
              ),
            ),

            const SizedBox(height: 8,),

            Column(
              children: [
                GestureDetector(
                  onTap: () => joinRandomGame(context),
                  child: const SizedBox(
                    width: 195,
                    child: PrimaryButton(text: "join random", color: kPink, isStatic: true)),
                ),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Textbox(text: "enter game id", color: kGreen, isObscure: false, controller: gameIdController)),
                    const SizedBox(width: 12,),
                    const PrimaryButton(text: "join", color: kWhite, isStatic: false),
                  ],
                )
                
              ],
            ),

            const SizedBox(height: 16,),

            GestureDetector(
              onTap: () {
                context.go('/home');
              },
              child: Text(
                "go back",
                style: GoogleFonts.shareTech(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: kYellow
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}