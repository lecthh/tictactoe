import 'package:final_proj/services/auth_service.dart';
import 'package:final_proj/utils/app_colors.dart';
import 'package:final_proj/utils/primary_button.dart';
import 'package:final_proj/utils/textbox.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


// ignore: must_be_immutable
class Signin extends StatelessWidget {
  Signin({super.key});

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBlack,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "tic\ntac\ntoe",
                textAlign: TextAlign.center,
                style: GoogleFonts.shareTech(
                  textStyle: const TextStyle(
                    color: kGreen,
                    fontSize: 32,
                    height: 1.2
                  )
                ),
              ),

              const SizedBox(height: 16,),

              Column(
                children: [
                  Textbox(text: "username", color: kGreen, isObscure: false, controller: usernameController),
                  const SizedBox(height: 8,),
                  Textbox(text: "password", color: kGreen, isObscure: true, controller: passwordController)
                ],
              ),

              const SizedBox(height: 16,),
              GestureDetector(
                onTap: () async {
                  final authService = AuthService();
                  final user = await authService.signIn(
                    usernameController.text,
                    passwordController.text
                  );

                  if (user != null) {
                    // ignore: use_build_context_synchronously
                    context.go('/home');
                  } else {
                    const SnackBar(
                      content: Text(
                        "Error signing up"
                      ),
                    );
                  }
                },
                child: const PrimaryButton(text: "sign in", color: kWhite, isStatic: true)
              ),
              const SizedBox(height: 16,),

              GestureDetector(
                onTap: () => context.go('/signup'),
                child: Text(
                  "create an account",
                  style: GoogleFonts.shareTech(
                    textStyle: const TextStyle(
                      color: kYellow,
                      fontSize: 16,
                    )
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}