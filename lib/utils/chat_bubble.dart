import 'package:final_proj/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final Color bubbleColor; 

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.bubbleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.shareTech(
          color: kWhite,
          fontSize: 16,
        ),
      ),
    );
  }
}
