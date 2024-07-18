import 'package:final_proj/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Textbox extends StatelessWidget {
  final String text;
  final Color color;
  final bool isObscure;
  final TextEditingController controller;
  
  const Textbox({super.key, required this.text, required this.color, required this.isObscure, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        obscuringCharacter: '*',
        cursorColor: kGreen,
        style: GoogleFonts.shareTech(
          fontSize: 16,
          color: color
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: text,
          hintStyle: GoogleFonts.shareTech(
            fontSize: 16,
            color: color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: color,
              width: 2
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: color,
              width: 2
            )
          )
        ),
      ),
    );
  }
}