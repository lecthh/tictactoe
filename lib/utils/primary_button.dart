import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool isStatic;

  const PrimaryButton({super.key, required this.text, required this.color, required this.isStatic});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 2,
        )
      ),
      width: isStatic ? 168: null,
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.shareTech(
                fontSize: 16,
                color: color
              ),
            ),
          ),
        ),
      ),
    );
  }
}