// ============================================================================
// SCREEN: Login & Sign Up Screen
// FILE: lib/screens/login_signup_screen.dart
// PURPOSE: Authentication screen with Sign In, Sign Up, Guest Bypass, & Demo Autofill.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Login screen hatao! Mujhe direct Main/Home screen dikhao!"
//    - OPTION 1 (Instant): In lib/core/app_config.dart, set:
//        AppConfig.requireLogin = false;
//    - OPTION 2 (Main Route): In lib/main.dart, change:
//        initialRoute: AppRoutes.mainShell,
//    - OPTION 3 (Live UI): Just tap the "Continue as Guest" button on this screen!
// 2. TEACHER: "Check karo validation chalti hai ya nahi?"
//    - Empty fields will trigger clear red validation messages immediately.
// 3. TEACHER: "Jaldi se login karo time nahi hai!"
//    - Tap "Demo Credentials" chip to auto-populate email & password instantly!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/app_routes.dart';
import '../core/app_config.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLogin = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    setState(() {
      _emailController.text = AppConfig.demoEmail;
      _passwordController.text = AppConfig.demoPassword;
      if (!isLogin) {
        _nameController.text = AppConfig.demoName;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Demo credentials filled successfully'),
        backgroundColor: AppTheme.accentTeal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate authentication delay
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLogin ? 'Welcome back!' : 'Account created successfully!'),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pushReplacementNamed(AppRoutes.mainShell);
  }

  void _continueAsGuest() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.mainShell);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.flight_takeoff, size: 36, color: Colors.white),
                      ),
                      // Quick Demo Pill for fast viva testing
                      ActionChip(
                        avatar: const Icon(Icons.flash_on, size: 18, color: Colors.amber),
                        label: const Text('Demo Fill', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        backgroundColor: Colors.amber.withValues(alpha: 0.15),
                        side: BorderSide(color: Colors.amber.shade400),
                        onPressed: _fillDemoCredentials,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isLogin ? 'Welcome back' : 'Create an account',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLogin
                        ? 'Sign in to access your planned trips and personalized AI recommendations'
                        : 'Start your journey with Pakistan\'s smartest AI travel planner',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Name Field (Sign Up Only)
                  if (!isLogin) ...[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (!isLogin && (value == null || value.trim().isEmpty)) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  // Forgot Password (Sign In Only)
                  if (isLogin) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Primary Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              isLogin ? 'Sign In' : 'Create Account',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Guest Bypass Button (Teacher Defense Feature)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.person_pin_circle_outlined),
                      label: const Text(
                        'Continue as Guest',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      onPressed: _continueAsGuest,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Toggle between Sign In and Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin ? 'Don\'t have an account?' : 'Already have an account?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                            _formKey.currentState?.reset();
                          });
                        },
                        child: Text(
                          isLogin ? 'Sign Up' : 'Sign In',
                          style: const TextStyle(
                            color: AppTheme.accentTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
