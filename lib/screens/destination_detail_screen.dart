// ============================================================================
// SCREEN: Destination Detail Screen
// FILE: lib/screens/destination_detail_screen.dart
// PURPOSE: Full-bleed hero image, dynamic ratings, highlights, pricing, saved places
//          toggle, "View Pre-Planned Trips", and "Ask AI Assistant About This Place".
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// To remove or hide ANY component on this screen, find its conspicuous
// 🔴 [START] and 🔴 [END] comment banners below. Each banner gives you
// exact instructions on how to comment it out or toggle it!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'pre_planned_trip_screen.dart';
import 'chat_screen.dart';
import 'trip_preferences_screen.dart';
import '../core/saved_places_service.dart';
import '../core/app_config.dart';
import '../widgets/unsplash_image.dart';

class DestinationDetailScreen extends StatefulWidget {
  const DestinationDetailScreen({super.key});

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  late SavedPlacesService _savedPlacesService;
  late Map<String, dynamic> _destination;

  @override
  void initState() {
    super.initState();
    _savedPlacesService = SavedPlacesService();
    _savedPlacesService.addListener(_onSavedPlacesChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _destination = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  void _onSavedPlacesChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _savedPlacesService.removeListener(_onSavedPlacesChanged);
    super.dispose();
  }

  bool get _isSaved => _savedPlacesService.isPlaceSaved(_destination['id'], _destination['name']?.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            // ======================================================
            // 🔴 [START] BUTTON: Back Arrow Icon
            // DESCRIPTION: Pops back to previous screen (Home or Trips).
            // 🎓 TO HIDE THIS BUTTON:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            // ======================================================
            // 🔴 [END] BUTTON: Back Arrow Icon
            // ======================================================

            actions: [
              // ======================================================
              // 🔴 [START] BUTTON: Save / Bookmark Place Icon
              // DESCRIPTION: Saves or removes this destination from wishlist.
              // 🎓 TO HIDE THIS BUTTON:
              //    METHOD 1: Set AppConfig.enableSavedPlaces = false; in lib/core/app_config.dart
              //    METHOD 2: Comment out lines from [START] to [END] of this block.
              // ======================================================
              if (AppConfig.enableSavedPlaces)
                IconButton(
                  tooltip: _isSaved ? 'Remove from saved' : 'Save place',
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isSaved
                          ? AppTheme.accentTeal
                          : Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  onPressed: () {
                    final wasAlreadySaved = _isSaved;
                    _savedPlacesService.togglePlace(_destination);
                    setState(() {});

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              wasAlreadySaved ? Icons.bookmark_outline : Icons.bookmark,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              wasAlreadySaved
                                  ? 'Removed from saved places'
                                  : 'Saved to your wishlist!',
                            ),
                          ],
                        ),
                        backgroundColor: wasAlreadySaved
                            ? Colors.grey.shade800
                            : AppTheme.accentTeal,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              // ======================================================
              // 🔴 [END] BUTTON: Save / Bookmark Place Icon
              // ======================================================
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  UnsplashImage(
                    query: _destination['name'],
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          AppTheme.background,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _destination['name'],
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: AppTheme.accentTeal, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  _destination['country'],
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentTeal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(height: 4),
                            Text(
                              _destination['rating'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Chips (Price and Distance)
                  Row(
                    children: [
                      _buildInfoChip(context, Icons.account_balance_wallet, 'PKR ${_destination["price"]}'),
                      const SizedBox(width: 16),
                      _buildInfoChip(context, Icons.map_outlined, _destination['distance']),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text('About', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Text(
                    _destination['description'],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  Text('Tags', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (_destination['tags'] as List<String>).map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade200),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // ======================================================
      // 🔴 [START] BOTTOM BAR: Book Now & Customize Buttons
      // DESCRIPTION: Action bar containing "Book Now" and "Customize (AI)".
      // 🎓 TO HIDE THESE BUTTONS:
      //    - To hide "Book Now": Comment out the first Expanded widget below!
      //    - To hide "Customize": Comment out the second Expanded widget below!
      //    - Or comment out lines from [START] to [END] of this block.
      // ======================================================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        color: Colors.white,
        child: Row(
          children: [
            // Book Now Button
            if (AppConfig.enableBooking)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrePlannedTripScreen(destination: _destination),
                        ),
                      );
                    },
                    child: const Text('Book Now'),
                  ),
                ),
              ),
            if (AppConfig.enableBooking && AppConfig.enableAiChat) const SizedBox(width: 12),

            // Customize / Dual Option Button
            if (AppConfig.enableAiChat)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: OutlinedButton(
                    onPressed: () => _showCustomizeOptionsModal(context),
                    child: const Text('Customize'),
                  ),
                ),
              ),
          ],
        ),
      ),
      // ======================================================
      // 🔴 [END] BOTTOM BAR: Book Now & Customize Buttons
      // ======================================================
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.accentTeal),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showCustomizeOptionsModal(BuildContext context) {
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
              'Customize Your Trip',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you would like to design your trip to ${_destination["name"]}:',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 20),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.pop(ctx);
                final message =
                    'I am interested in visiting ${_destination["name"]} in ${_destination["country"]}. Can you help me plan my customized trip?';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      initialMessage: message,
                      destination: _destination,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D9488),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Plan with AI Assistant',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Chat interactively to design your perfect daily plan with recommendations',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF0D9488)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TripPreferencesScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.tune, color: AppTheme.textPrimary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customize Manually',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Set your preferred travel pace, hotel budget, and transport style directly',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
