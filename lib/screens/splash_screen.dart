// ============================================================================
// SCREEN: Splash Screen
// FILE: lib/screens/splash_screen.dart
// PURPOSE: Animated entry screen showing the AI Travel Assistant logo and name.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Splash screen hatao, direct home ya login pe jao!"
//    - OPTION 1: In lib/main.dart, change:
//        initialRoute: AppRoutes.splash,  --->  initialRoute: AppRoutes.mainShell,
//    - OPTION 2: In lib/core/app_config.dart, set:
//        AppConfig.skipOnboarding = true;
//        AppConfig.requireLogin = false;
// 2. TEACHER: "Splash delay kam karo ya fast karo!"
//    - In lib/core/app_config.dart, set AppConfig.fastSplash = true; (Line 27 below)
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/app_routes.dart';
import '../core/app_config.dart';
import '../core/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    final int delaySeconds = AppConfig.fastSplash ? 1 : 3;

    Future.delayed(Duration(seconds: delaySeconds), () async {
      if (!mounted) return;

      final bool loggedIn = await AuthService.isLoggedIn();
      if (!mounted) return;

      if (loggedIn) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.mainShell);
        return;
      }

      if (AppConfig.skipOnboarding) {
        if (AppConfig.requireLogin) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.loginSignup);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.mainShell);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=2073&auto=format&fit=crop',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: 0.6),
                  AppTheme.primaryBlue.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.flight_takeoff,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'AI Travel\nAssistant',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            height: 1.2,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
