// ============================================================================
// SERVICE: Authentication & Session Persistence Service
// FILE: lib/core/auth_service.dart
// PURPOSE: Persistent login state using SharedPreferences so user session
//          is preserved across app restarts, reboots, and hot restarts.
// ============================================================================

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'app_user_is_logged_in';
  static const String _keyUserEmail = 'app_user_email';
  static const String _keyUserName = 'app_user_name';

  /// Check whether a user is currently signed in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Get current user email
  static Future<String> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserEmail) ?? 'muhammadali@gmail.com';
    } catch (_) {
      return 'muhammadali@gmail.com';
    }
  }

  /// Get current user display name
  static Future<String> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserName) ?? 'Muhammad Ali';
    } catch (_) {
      return 'Muhammad Ali';
    }
  }

  /// Save active sign in session
  static Future<void> saveLoginSession({
    required String email,
    String? name,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserEmail, email.trim());
      if (name != null && name.trim().isNotEmpty) {
        await prefs.setString(_keyUserName, name.trim());
      }
    } catch (_) {}
  }

  /// Clear session on explicit user logout
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, false);
      await prefs.remove(_keyUserEmail);
      await prefs.remove(_keyUserName);
    } catch (_) {}
  }
}
