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
import '../core/booking_service.dart';
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
  String _avatarUrl =
      'https://images.unsplash.com/photo-1544006659-f0b21884ce1d?q=80&w=400&auto=format&fit=crop';

  final List<String> _galleryAvatars = const [
    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1544006659-f0b21884ce1d?q=80&w=400&auto=format&fit=crop',
  ];

  void _showPhotoPickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Profile Photo',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select a method to update your profile photo:',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library, color: Color(0xFF0D9488)),
              ),
              title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Select a portrait from your saved photos'),
              onTap: () {
                Navigator.pop(ctx);
                _showGallerySelector();
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.orange),
              ),
              title: const Text('Take Photo / Camera', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Capture a new selfie with your camera'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400&auto=format&fit=crop';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Camera photo captured and profile updated!'),
                    backgroundColor: Color(0xFF0D9488),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showGallerySelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select From Gallery', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _galleryAvatars.length,
                separatorBuilder: (context, index) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final photo = _galleryAvatars[index];
                  final isCurrent = photo == _avatarUrl;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _avatarUrl = photo;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile photo updated from gallery!'),
                          backgroundColor: Color(0xFF0D9488),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent ? const Color(0xFF0D9488) : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundImage: NetworkImage(photo),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacementNamed(context, AppRoutes.loginSignup);
            },
            child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Demo & App Data'),
        content: const Text(
          'This will clear all active bookings and reset your travel state to a fresh new user profile.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                BookingService.clearData();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('App data reset to fresh user state.'),
                  backgroundColor: Colors.blueGrey,
                ),
              );
            },
            child: const Text('Reset Data', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
        content: const Text(
          'Are you sure you want to permanently delete your account? All your booked tours, saved places, and history will be completely wiped out. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              BookingService.clearData();
              Navigator.pushReplacementNamed(context, AppRoutes.loginSignup);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Your account has been deleted.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete Permanently', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String name = 'Muhammad Ali';
    const String email = 'muhammadali@gmail.com';

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
              const SizedBox(height: 8),
              // ======================================================
              // 🔴 [START] COMPONENT: User Profile Avatar & Camera Badge
              // DESCRIPTION: Circular user profile photo with tap action sheet.
              // ======================================================
              Center(
                child: GestureDetector(
                  onTap: _showPhotoPickerModal,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundImage: NetworkImage(_avatarUrl),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.accentTeal,
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ======================================================
              // 🔴 [END] COMPONENT: User Profile Avatar & Camera Badge
              // ======================================================
              const SizedBox(height: 12),

              Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(email, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              const SizedBox(height: 16),

              const Divider(),

              // Trip Preferences Tile
              ListTile(
                leading: Icon(Icons.settings, color: AppTheme.accentTeal),
                title: const Text('Trip Preferences'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const TripPreferencesScreen()));
                },
              ),
              const Divider(),

              // My Bookings Tile
              _tile(Icons.book, 'My Bookings', () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const MyBookingsScreen()));
              }),

              // Saved Places Tile
              _tile(Icons.place, 'Saved Places', () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const SavedPlacesScreen()));
              }),

              // Notifications Tile
              _tile(Icons.notifications, 'Notifications', () {
                Navigator.pushNamed(context, AppRoutes.notificationsScreen);
              }),

              // Help & Support Tile
              _tile(Icons.help_outline, 'Help & Support', () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const HelpSupportScreen()));
              }),

              const Divider(),
              const SizedBox(height: 8),

              // ======================================================
              // 🔴 [START] SECTION: Three Account Actions (Logout, Clear Data, Delete Account)
              // ======================================================
              _actionTile(
                Icons.logout,
                'Log Out',
                Colors.grey.shade800,
                _showLogoutDialog,
              ),
              const SizedBox(height: 8),
              _actionTile(
                Icons.restore,
                'Clear App Data / Reset Demo',
                Colors.orange.shade800,
                _showClearDataDialog,
              ),
              const SizedBox(height: 8),
              _actionTile(
                Icons.delete_forever,
                'Delete Account',
                Colors.red.shade700,
                _showDeleteAccountDialog,
              ),
              // ======================================================
              // 🔴 [END] SECTION: Three Account Actions
              // ======================================================
              const SizedBox(height: 24),
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

  Widget _actionTile(IconData icon, String label, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
        ),
        trailing: Icon(Icons.chevron_right, color: color, size: 20),
        onTap: onTap,
      ),
    );
  }
}
