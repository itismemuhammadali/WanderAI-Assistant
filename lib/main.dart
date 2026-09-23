// ============================================================================
// MAIN APPLICATION ENTRY POINT
// FILE: lib/main.dart
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "App shuru hote hi direct Main Screen (Home) dikhao! Splash/Login hatao!"
//    - Change Line 36 below:
//      initialRoute: AppRoutes.splash,  --->  initialRoute: AppRoutes.mainShell,
//
// 2. TEACHER: "App shuru hote hi direct Login dikhao!"
//    - Change Line 36 below:
//      initialRoute: AppRoutes.splash,  --->  initialRoute: AppRoutes.loginSignup,
//
// 3. TEACHER: "Kisi screen ko routes se permanently disable/redirect karna hai?"
//    - Change the destination widget in the `routes` map (Line 38-51).
//      Example: AppRoutes.onboarding: (context) => const MainShell(),
// ============================================================================

import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/app_routes.dart';
import 'core/app_config.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/main_shell.dart';
import 'screens/destination_detail_screen.dart';
import 'screens/map_screen.dart';
import 'screens/route_attractions_screen.dart';
import 'screens/booking_summary_screen.dart';
import 'screens/booking_confirmation_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  runApp(const TravelAssistantApp());
}

class TravelAssistantApp extends StatelessWidget {
  const TravelAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Travel Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // 🎓 TEACHER TRICK: Toggle AppConfig flags in lib/core/app_config.dart
      // (fastSplash, skipOnboarding, requireLogin) or override initialRoute directly:
      initialRoute: AppConfig.fastSplash
          ? AppRoutes.mainShell
          : (AppConfig.skipOnboarding
              ? (AppConfig.requireLogin ? AppRoutes.loginSignup : AppRoutes.mainShell)
              : AppRoutes.splash),

      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.loginSignup: (context) => const LoginSignupScreen(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
        AppRoutes.mainShell: (context) => const MainShell(),
        AppRoutes.destinationDetail: (context) => const DestinationDetailScreen(),
        AppRoutes.mapScreen: (context) => const MapScreen(),
        AppRoutes.routeAttractions: (context) => const RouteAttractionsScreen(),
        AppRoutes.bookingSummary: (context) => const BookingSummaryScreen(),
        AppRoutes.bookingConfirmation: (context) => const BookingConfirmationScreen(),
        AppRoutes.notificationsScreen: (context) => const NotificationsScreen(),
      },
    );
  }
}
