// ============================================================================
// MASTER APP CONFIGURATION & TEACHER DEFENSE TOGGLES
// FILE: lib/core/app_config.dart
//
// 🎓 VIVA / DEMO EMERGENCY CONTROLS:
// If your teacher asks you to remove, skip, or disable any screen or feature
// during your presentation, change the boolean values below and hot reload!
// ============================================================================

class AppConfig {
  // --------------------------------------------------------------------------
  // 1. SCREEN FLOW & BYPASS CONTROLS
  // --------------------------------------------------------------------------

  /// Skip Onboarding screen entirely.
  /// If TRUE: Splash goes directly to Login (or Main Screen if requireLogin is false).
  static bool skipOnboarding = false;

  /// Require user to Login/Signup before seeing the app.
  /// If FALSE: Splash/Onboarding goes directly to Main Screen (Home).
  static bool requireLogin = true;

  /// Bypass Splash screen delay (useful for rapid demo).
  static bool fastSplash = false;

  // --------------------------------------------------------------------------
  // 2. AUTHENTICATION & LOGIN/SIGNUP SPECIFIC CONTROLS
  // --------------------------------------------------------------------------

  /// Allow user to switch to Sign Up mode.
  /// 🎓 TEACHER SAYS: "Remove the Sign Up screen/feature! We only want Login!"
  /// -> SET THIS TO FALSE! The Sign Up toggle disappears and screen is 100% Login-only.
  static bool allowSignUp = true;

  /// Allow "Continue as Guest" bypass button.
  /// 🎓 TEACHER SAYS: "Remove guest login, force user to enter credentials!"
  /// -> SET THIS TO FALSE!
  static bool allowGuestLogin = true;

  /// Allow "Demo Fill" autofill chip button.
  /// 🎓 TEACHER SAYS: "Remove the demo autofill button!"
  /// -> SET THIS TO FALSE!
  static bool allowDemoFill = true;

  /// Allow "Forgot Password" link on login screen.
  /// 🎓 TEACHER SAYS: "Remove forgot password!"
  /// -> SET THIS TO FALSE!
  static bool allowForgotPassword = true;

  // --------------------------------------------------------------------------
  // 3. FEATURE TOGGLES (Hide/Show specific features in 1 second)
  // --------------------------------------------------------------------------

  /// Enable or disable AI Travel Assistant Chatbot tab/floating button.
  static bool enableAiChat = true;

  /// Enable dual route comparison on Route Attractions Screen.
  static bool enableDualRoutes = true;

  /// Enable Booking flow and checkout screens.
  static bool enableBooking = true;

  /// Enable Notifications Screen.
  static bool enableNotifications = true;

  /// Enable Search Filters Screen.
  static bool enableFilters = true;

  /// Enable Saved Places / Favorites feature.
  static bool enableSavedPlaces = true;

  /// Enable Pre-planned Trips generator.
  static bool enablePrePlannedTrips = true;

  // --------------------------------------------------------------------------
  // 4. DEMO FAST CREDENTIALS (Quick fill to avoid typing live during viva)
  // --------------------------------------------------------------------------

  static const String demoEmail = "ali.traveler@example.com";
  static const String demoPassword = "Password123!";
  static const String demoName = "Muhammad Ali";

  // --------------------------------------------------------------------------
  // 5. BACKEND CONNECTION INFO
  // --------------------------------------------------------------------------
  static const String backendBaseUrl = "http://localhost:8000";
  static const String supabaseProjectUrl = "https://ownqlxoygmlsqrechjkv.supabase.co";
}
