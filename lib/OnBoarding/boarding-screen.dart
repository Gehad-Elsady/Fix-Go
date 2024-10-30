import 'package:flutter/material.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/OnBoarding/OnboardingPage1.dart';
import 'package:road_mate/OnBoarding/OnboardingPage2.dart';
import 'package:road_mate/OnBoarding/OnboardingPage3.dart';
import 'package:road_mate/theme/app-colors.dart';

// import 'package:recycling_app/home-screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = 'onboarding-screen';

  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.backGround,
          ),
        ),
        child: Stack(
          children: [
            // PageView to swipe through onboarding pages
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                OnboardingPage1(), // First page
                OnboardingPage2(), // Second page
                OnboardingPage3(), // Third page
              ],
            ),

            // Skip button at the top right
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Bottom navigation buttons
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator dots
                  Row(
                    children: List.generate(
                      3, // Total number of pages
                      (index) => _buildIndicator(index == _currentIndex),
                    ),
                  ),
                  // Next or Get Started button
                  GestureDetector(
                    onTap: () {
                      if (_currentIndex == 2) {
                        // Last page
                        Navigator.pushReplacementNamed(
                            context, LoginPage.routeName);
                      } else {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Text(
                      _currentIndex == 2 ? 'Get Started' : 'Next',
                      style: TextStyle(
                        color: Color(0xfff4e285),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Page indicator for the dots at the bottom
  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 8,
      width: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
