// ============================================================================
// SCREEN: Onboarding Screen
// FILE: lib/screens/onboarding_screen.dart
// PURPOSE: Multi-slide introduction showcasing app capabilities (Hunza, Skardu, Swat).
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Onboarding screen hata do aur direct Login ya Home pe jao!"
//    - OPTION 1: In lib/core/app_config.dart, set:
//        AppConfig.skipOnboarding = true;
//    - OPTION 2: In lib/main.dart, change:
//        AppRoutes.onboarding: (context) => const MainShell(),
// 2. TEACHER: "Onboarding se seedha Main Screen pe jao without login!"
//    - In lib/core/app_config.dart, set:
//        AppConfig.requireLogin = false;
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/app_routes.dart';
import '../core/app_config.dart';
import '../core/dummy_data.dart';
import '../widgets/unsplash_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _navigateToNext() {
    if (AppConfig.requireLogin) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginSignup);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainShell);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: DummyData.onboardingSlides.length,
            itemBuilder: (context, index) {
              final slide = DummyData.onboardingSlides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  UnsplashImage(
                    query: slide['query'] ?? 'Hunza Valley landscape mountains',
                    fallbackUrl: slide['image'],
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.primaryBlue.withValues(alpha: 0.9),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slide['title']!,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                height: 1.2,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['description']!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 48,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    DummyData.onboardingSlides.length,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? AppTheme.accentTeal : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                _currentPage == DummyData.onboardingSlides.length - 1
                    ? ElevatedButton(
                        onPressed: _navigateToNext,
                        child: const Text('Get Started'),
                      )
                    : TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ),
          if (_currentPage != DummyData.onboardingSlides.length - 1)
            Positioned(
              top: 60,
              right: 24,
              child: TextButton(
                onPressed: _navigateToNext,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
