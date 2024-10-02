import 'package:flutter/material.dart';
import 'package:reels/presentation/Screens/home_page.dart';
import 'package:reels/presentation/Screens/onboarding.dart';

void main() {
  runApp(const ReelsApp());
}

class ReelsApp extends StatelessWidget {
  const ReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomePage.id: (context) => const HomePage(),
        OnboardingScreen.id: (context) => OnboardingScreen(),
      },
      initialRoute:OnboardingScreen.id,
      
    );
  }
}
