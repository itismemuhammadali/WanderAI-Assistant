import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/app_routes.dart';
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
                        onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.loginSignup),
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
                onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.loginSignup),
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
