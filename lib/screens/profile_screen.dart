// ============================================================================
// SCREEN: User Profile Screen
// FILE: lib/screens/profile_screen.dart
// PURPOSE: Displays user avatar, account details, and navigation links to My Bookings,
//          Saved Places, Travel Preferences, Help & Support, and Logout dialog.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Profile Screen se koi option hata do (e.g. Help & Support ya My Bookings)!"
//    - Look at the ListTiles in the build method (Lines 60-110). Comment out any tile!
// 2. TEACHER: "Logout dialog ka confirmation bypass karo!"
//    - Call `Navigator.of(context).pushReplacementNamed(AppRoutes.loginSignup);` directly.
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../core/app_routes.dart';
import 'trip_preferences_screen.dart';
import 'my_bookings_screen.dart';
import 'help_support_screen.dart';
import 'saved_places_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () {
            Navigator.of(ctx).pop();
            Navigator.pushReplacementNamed(context, AppRoutes.loginSignup);
          }, child: const Text('Logout')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dummy user data
    const String name = 'Muhammad Ali';
    const String username = '@muhammadali';
    const String email = 'muhammadali@gmail.com';
    const int age = 28;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              // ======================================================
              // 🔴 [START] COMPONENT: User Profile Avatar & Camera Badge
              // DESCRIPTION: Circular user profile photo with camera icon overlay.
              // 🎓 TO HIDE THIS COMPONENT:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 54,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1544006659-f0b21884ce1d?q=80&w=400&auto=format&fit=crop'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppTheme.accentTeal,
                        child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // ======================================================
              // 🔴 [END] COMPONENT: User Profile Avatar & Camera Badge
              // ======================================================
              const SizedBox(height: 12),

              // ======================================================
              // 🔴 [START] COMPONENT: User Profile Info Details
              // DESCRIPTION: Displays traveler name, handle, email, and age.
              // 🎓 TO HIDE THIS COMPONENT:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(username, style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 4),
              Text(email, style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 4),
              Text('Age $age', style: TextStyle(color: AppTheme.textSecondary)),
              // ======================================================
              // 🔴 [END] COMPONENT: User Profile Info Details
              // ======================================================
              const SizedBox(height: 16),

              const Divider(),

              // ======================================================
              // 🔴 [START] TILE: Trip Preferences
              // DESCRIPTION: Opens preferences screen to customize travel pace and interests.
              // 🎓 TO HIDE THIS TILE:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              ListTile(
                leading: Icon(Icons.settings, color: AppTheme.accentTeal),
                title: const Text('Trip Preferences'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const TripPreferencesScreen()));
                },
              ),
              // ======================================================
              // 🔴 [END] TILE: Trip Preferences
              // ======================================================
              const Divider(),

              // ======================================================
              // 🔴 [START] TILE: My Bookings
              // DESCRIPTION: Navigates to user booking history and active trip cards.
              // 🎓 TO HIDE THIS TILE:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              _tile(Icons.book, 'My Bookings', () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const MyBookingsScreen()));
              }),
              // ======================================================
              // 🔴 [END] TILE: My Bookings
              // ======================================================

              // ======================================================
              // 🔴 [START] TILE: Saved Places
              // DESCRIPTION: Opens list of bookmarked Pakistani attractions and valleys.
              // 🎓 TO HIDE THIS TILE:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              _tile(Icons.place, 'Saved Places', () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const SavedPlacesScreen()));
              }),
              // ======================================================
              // 🔴 [END] TILE: Saved Places
              // ======================================================

              // ======================================================
              // 🔴 [START] TILE: Notifications
              // DESCRIPTION: Opens alert center for weather alerts and trip reminders.
              // 🎓 TO HIDE THIS TILE:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              _tile(Icons.notifications, 'Notifications', () {
                Navigator.pushNamed(context, AppRoutes.notificationsScreen);
              }),
              // ======================================================
              // 🔴 [END] TILE: Notifications
              // ======================================================

              // ======================================================
              // 🔴 [START] TILE: Help & Support
              // DESCRIPTION: Displays FAQs accordion and direct support channels.
              // 🎓 TO HIDE THIS TILE:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              _tile(Icons.help_outline, 'Help & Support', () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const HelpSupportScreen()));
              }),
              // ======================================================
              // 🔴 [END] TILE: Help & Support
              // ======================================================

              // ======================================================
              // 🔴 [START] TILE: Logout
              // DESCRIPTION: Shows confirmation dialog and redirects to Login Screen.
              // 🎓 TO HIDE THIS TILE:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              _tile(Icons.logout, 'Logout', _showLogoutDialog),
              // ======================================================
              // 🔴 [END] TILE: Logout
              // ======================================================
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentTeal),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
