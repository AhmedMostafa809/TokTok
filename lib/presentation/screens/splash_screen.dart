import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:toktokapp/main.dart';
import 'package:toktokapp/presentation/screens/phone_auth_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // initDependencies();
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset(
          "assets/animations/SplashAnimation.json",
          fit: BoxFit.contain,
        ),
      ),
      splashIconSize: 100.w,
      duration: 4000,
      nextScreen: const PhoneAuthScreen(),
      splashTransition: SplashTransition.fadeTransition,

    );
  }
}