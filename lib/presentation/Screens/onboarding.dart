import 'package:flutter/material.dart';
import 'package:reels/presentation/Screens/home_page.dart';
import 'package:reels/data/models/onboarding_data_model.dart';
import 'package:reels/helper/conatants.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = "OnboardingScreen";
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

final List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    title: "Welcome to Reels!",
    description:
        "Dive into a world of exciting reels and endless entertainment.",
    imagePath: "assets/images/video-marketing.png",
  ),
  OnboardingPage(
    title: "Explore Trending Reels",
    description:
        "Discover the latest trends and popular reels from creators around the globe.",
    imagePath: "assets/images/film-reel.png",
  ),
  OnboardingPage(
    title: "Share Your Creativity",
    description:
        "Create and share your own reels to entertain and inspire others.",
    imagePath: "assets/images/movie-reel.png",
  ),
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacementNamed(context, HomePage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromARGB(255, 108, 173, 125)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: onboardingPages.length,
          itemBuilder: (context, index) {
            final page = onboardingPages[index];
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height:120),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(page.imagePath),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      page.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        page.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 175,
                        top: 10,
                      ),
                      child: Row(
                        children:
                            List.generate(onboardingPages.length, (index) {
                          return buildDot(index);
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == onboardingPages.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: primarycolor,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Container buildDot(int index) {
    return Container(
      height: 10,
      width: _currentPage == index ? 30 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? primarycolor : Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
