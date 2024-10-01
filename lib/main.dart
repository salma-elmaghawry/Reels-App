import 'package:flutter/material.dart';
import 'package:reels/Screens/home_page.dart';
import 'package:reels/Screens/onboarding.dart';

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
        Onboarding.id: (context) => const Onboarding(),
      },
      initialRoute: HomePage.id,
    );
  }
}
