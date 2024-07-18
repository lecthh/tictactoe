import 'package:dotted_border/dotted_border.dart';
import 'package:final_proj/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TttBox extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const TttBox({super.key, this.value = "", required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: kGreen,
        strokeWidth: 2,
        child: SizedBox(
          width: 60,
          height: 60,
          child: Center(
            child: Text(
              value.isEmpty ? "" : value == "1" ? "X" : "O",
              style: GoogleFonts.shareTech(
                color: kWhite,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
