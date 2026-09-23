// ============================================================================
// SCREEN: Login & Sign Up Screen
// FILE: lib/screens/login_signup_screen.dart
// PURPOSE: Unified authentication screen supporting Sign In, Sign Up, Guest Bypass,
//          and Demo Autofill for rapid viva testing.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Login screen poori app se hatao! Direct Home dikhao!"
//    -> In lib/core/app_config.dart, set: AppConfig.requireLogin = false;
//    -> Or in lib/main.dart, set: initialRoute: AppRoutes.mainShell;
//
// 2. TEACHER: "Sign Up hata do, app me sirf Login hona chahiye!"
//    -> In lib/core/app_config.dart, set: AppConfig.allowSignUp = false;
//    -> Or comment out the Toggle block at the bottom (clearly marked below)!
//
// 3. TEACHER: "Guest Login button hata do!"
//    -> In lib/core/app_config.dart, set: AppConfig.allowGuestLogin = false;
//    -> Or comment out the Guest Button block (clearly marked below)!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/app_routes.dart';
import '../core/app_config.dart';
import '../core/api_service.dart';

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

  // If allowSignUp is disabled in AppConfig, force isLogin to true permanently
  bool get isLogin => AppConfig.allowSignUp ? _isLoginMode : true;
  bool _isLoginMode = true;
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
      const SnackBar(
        content: Text('Demo credentials filled successfully'),
        backgroundColor: AppTheme.accentTeal,
        duration: Duration(seconds: 2),
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

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final fullName = _nameController.text.trim();

    Map<String, dynamic> result;
    if (isLogin) {
      result = await ApiService.login(
        email: email,
        password: password,
      );
    } else {
      result = await ApiService.signUp(
        email: email,
        password: password,
        fullName: fullName.isNotEmpty ? fullName : 'Traveler',
      );
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(result['message'] ?? (isLogin ? 'Welcome back!' : 'Account created successfully!')),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pushReplacementNamed(AppRoutes.mainShell);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(result['message'] ?? 'Authentication failed. Please try again.'),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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

                  // Header Row with App Logo and Demo Fill Button
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

                      // ======================================================
                      // 🔴 [START] BUTTON: Demo Credentials Quick Fill Chip
                      // DESCRIPTION: Automatically inputs valid email & password.
                      // 🎓 TO HIDE THIS BUTTON:
                      //    METHOD 1: Set AppConfig.allowDemoFill = false; in lib/core/app_config.dart
                      //    METHOD 2: Comment out lines from [START] to [END] of this block.
                      // ======================================================
                      if (AppConfig.allowDemoFill)
                        ActionChip(
                          avatar: const Icon(Icons.flash_on, size: 18, color: Colors.amber),
                          label: const Text('Demo Fill', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          backgroundColor: Colors.amber.withValues(alpha: 0.15),
                          side: BorderSide(color: Colors.amber.shade400),
                          onPressed: _fillDemoCredentials,
                        ),
                      // ======================================================
                      // 🔴 [END] BUTTON: Demo Credentials Quick Fill Chip
                      // ======================================================
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Screen Title
                  Text(
                    isLogin ? 'Welcome back' : 'Create an account',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Screen Subtitle
                  Text(
                    isLogin
                        ? 'Sign in to access your planned trips and personalized AI recommendations'
                        : 'Start your journey with Pakistan\'s smartest AI travel planner',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // ======================================================
                  // 🔴 [START] INPUT: Full Name Field (Sign Up Only)
                  // DESCRIPTION: Input field for new user registration.
                  // 🎓 TO HIDE THIS INPUT:
                  //    Comment out lines from [START] to [END] of this block.
                  // ======================================================
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
                  // ======================================================
                  // 🔴 [END] INPUT: Full Name Field
                  // ======================================================

                  // ======================================================
                  // 🔴 [START] INPUT: Email Address Field
                  // DESCRIPTION: Input for user account email.
                  // 🎓 TO HIDE THIS INPUT:
                  //    Comment out lines from [START] to [END] of this block.
                  // ======================================================
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
                  // ======================================================
                  // 🔴 [END] INPUT: Email Address Field
                  // ======================================================
                  const SizedBox(height: 16),

                  // ======================================================
                  // 🔴 [START] INPUT: Password Field (with Show/Hide Toggle)
                  // DESCRIPTION: Obscured password input with visibility toggle.
                  // 🎓 TO HIDE THIS INPUT:
                  //    Comment out lines from [START] to [END] of this block.
                  // ======================================================
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
                  // ======================================================
                  // 🔴 [END] INPUT: Password Field
                  // ======================================================

                  // ======================================================
                  // 🔴 [START] BUTTON: Forgot Password Text Button
                  // DESCRIPTION: Navigates to the password recovery screen.
                  // 🎓 TO HIDE THIS BUTTON:
                  //    METHOD 1: Set AppConfig.allowForgotPassword = false; in lib/core/app_config.dart
                  //    METHOD 2: Comment out lines from [START] to [END] of this block.
                  // ======================================================
                  if (isLogin && AppConfig.allowForgotPassword) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                  // ======================================================
                  // 🔴 [END] BUTTON: Forgot Password Text Button
                  // ======================================================

                  const SizedBox(height: 24),

                  // ======================================================
                  // 🔴 [START] BUTTON: Primary Sign In / Sign Up Submit Button
                  // DESCRIPTION: Submits the credentials and proceeds to MainShell.
                  // 🎓 TO HIDE THIS BUTTON:
                  //    Comment out lines from [START] to [END] of this block.
                  // ======================================================
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
                  // ======================================================
                  // 🔴 [END] BUTTON: Primary Sign In / Sign Up Submit Button
                  // ======================================================

                  const SizedBox(height: 12),

                  // ======================================================
                  // 🔴 [START] BUTTON: Continue as Guest (Viva Emergency Bypass)
                  // DESCRIPTION: Instantly bypasses authentication directly into Home.
                  // 🎓 TO HIDE THIS BUTTON:
                  //    METHOD 1: Set AppConfig.allowGuestLogin = false; in lib/core/app_config.dart
                  //    METHOD 2: Comment out lines from [START] to [END] of this block.
                  // ======================================================
                  if (AppConfig.allowGuestLogin)
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
                  // ======================================================
                  // 🔴 [END] BUTTON: Continue as Guest
                  // ======================================================

                  const SizedBox(height: 24),

                  // ======================================================
                  // 🔴 [START] COMPONENT: Sign Up / Sign In Toggle Switcher
                  // DESCRIPTION: Toggles between Login and Registration mode.
                  // 🎓 TEACHER SAYS: "Remove the Sign Up screen/feature entirely!"
                  //    METHOD 1: Set AppConfig.allowSignUp = false; in lib/core/app_config.dart
                  //    METHOD 2: Comment out lines from [START] to [END] of this block.
                  //    RESULT: User will only ever see Sign In. Sign Up is 100% hidden.
                  // ======================================================
                  if (AppConfig.allowSignUp)
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
                              _isLoginMode = !_isLoginMode;
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
                  // ======================================================
                  // 🔴 [END] COMPONENT: Sign Up / Sign In Toggle Switcher
                  // ======================================================
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
