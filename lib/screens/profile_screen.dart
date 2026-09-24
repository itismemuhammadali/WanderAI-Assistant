// ============================================================================
// SCREEN: User Profile Screen
// FILE: lib/screens/profile_screen.dart
// PURPOSE: Displays user avatar, account details, and navigation links to My Bookings,
//          Saved Places, Travel Preferences, Help and Support, real device photo picker,
//          and 3 tier account actions (Logout, Delete User Data, Delete Account).
// ============================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../core/app_routes.dart';
import '../core/booking_service.dart';
import '../core/auth_service.dart';
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
  final String _avatarUrl =
      'https://images.unsplash.com/photo-1544006659-f0b21884ce1d?q=80&w=400&auto=format&fit=crop';
  File? _localImageFile;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    try {
      if (Platform.isAndroid) {
        final photosStatus = await Permission.photos.status;
        if (photosStatus.isDenied) {
          await Permission.photos.request();
        }
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _localImageFile = File(image.path);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile photo updated from device gallery!'),
              backgroundColor: Color(0xFF0D9488),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking from gallery: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open gallery: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  Future<void> _takePhotoWithCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Camera permission permanently denied. Open settings to enable.'),
              backgroundColor: Colors.orange.shade800,
              action: SnackBarAction(
                label: 'Settings',
                textColor: Colors.white,
                onPressed: openAppSettings,
              ),
            ),
          );
        }
        return;
      }

      if (!status.isGranted && !status.isLimited) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission was not granted.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _localImageFile = File(photo.path);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New portrait captured with camera!'),
              backgroundColor: Color(0xFF0D9488),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open camera: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

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
              'Select a photo from your device or capture a fresh selfie:',
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
              subtitle: const Text('Open device photos to select a picture'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImageFromGallery();
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
              subtitle: const Text('Launch device camera to take a photo'),
              onTap: () {
                Navigator.pop(ctx);
                _takePhotoWithCamera();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await AuthService.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.loginSignup);
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDataDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User Data'),
        content: const Text(
          'This will erase all your saved preferences, cached trip details, and booking records while keeping your account active.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                BookingService.clearData();
                _localImageFile = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All user data and bookings have been erased.'),
                  backgroundColor: Colors.blueGrey,
                ),
              );
            },
            child: const Text('Delete Data', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
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
            onPressed: () async {
              Navigator.of(ctx).pop();
              BookingService.clearData();
              await AuthService.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.loginSignup);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your account has been deleted.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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
              // User Profile Avatar and Camera Badge
              Center(
                child: GestureDetector(
                  onTap: _showPhotoPickerModal,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundImage: _localImageFile != null
                            ? FileImage(_localImageFile!) as ImageProvider
                            : NetworkImage(_avatarUrl),
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
              const SizedBox(height: 16),
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 12),

              // Demo Bookings Loader Quick Button
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    BookingService.loadDemoData();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Demo bookings populated! Check My Bookings.'),
                      backgroundColor: Color(0xFF0D9488),
                    ),
                  );
                },
                icon: const Icon(Icons.playlist_add_check, size: 18),
                label: const Text('Load Demo Bookings'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: Colors.teal.shade300),
                ),
              ),
              const SizedBox(height: 24),

              // Account Options
              _tile(Icons.tune, 'Travel Preferences', () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const TripPreferencesScreen()));
              }),

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

              // Help and Support Tile
              _tile(Icons.help_outline, 'Help and Support', () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const HelpSupportScreen()));
              }),

              const Divider(),
              const SizedBox(height: 8),

              // Three Account Actions (Logout, Delete User Data, Delete Account)
              _actionTile(
                Icons.logout,
                'Log Out',
                Colors.grey.shade800,
                _showLogoutDialog,
              ),
              const SizedBox(height: 8),
              _actionTile(
                Icons.delete_sweep,
                'Delete User Data',
                Colors.orange.shade800,
                _showDeleteUserDataDialog,
              ),
              const SizedBox(height: 8),
              _actionTile(
                Icons.delete_forever,
                'Delete Account',
                Colors.red.shade700,
                _showDeleteAccountDialog,
              ),
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
