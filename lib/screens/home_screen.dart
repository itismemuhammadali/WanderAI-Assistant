// ============================================================================
// SCREEN: Home Screen (Discover Dashboard)
// FILE: lib/screens/home_screen.dart
// PURPOSE: Primary dashboard displaying Top Picks, Quick Action buttons, Trips & Tours,
//          Popular Destinations across Pakistan, and Featured Collections.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// To remove or hide ANY component on this screen, find its conspicuous
// 🔴 [START] and 🔴 [END] comment banners below. Each banner gives you
// exact instructions on how to comment it out or toggle it via AppConfig!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../core/app_routes.dart';
import '../core/app_config.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/destination_card.dart';
import '../widgets/unsplash_image.dart';
import 'trips_screen.dart';
import 'chat_screen.dart';
import 'booking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover',
        actions: [
          // ======================================================
          // 🔴 [START] BUTTON: Notifications App Bar Icon
          // DESCRIPTION: Bell icon in top bar that opens NotificationsScreen.
          // 🎓 TO HIDE THIS BUTTON:
          //    METHOD 1: Set AppConfig.enableNotifications = false; in lib/core/app_config.dart
          //    METHOD 2: Comment out lines from [START] to [END] of this block.
          // ======================================================
          if (AppConfig.enableNotifications)
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.notificationsScreen);
              },
            ),
          // ======================================================
          // 🔴 [END] BUTTON: Notifications App Bar Icon
          // ======================================================
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Where to next?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 24),

            // ======================================================
            // 🔴 [START] INPUT: Search Destinations Bar
            // DESCRIPTION: Interactive search bar that taps into the Booking flow.
            // 🎓 TO HIDE THIS INPUT:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingScreen()));
                },
                child: const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Search destinations...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            // ======================================================
            // 🔴 [END] INPUT: Search Destinations Bar
            // ======================================================

            const SizedBox(height: 32),

            // ======================================================
            // 🔴 [START] SECTION: Top Picks Horizontal Carousel
            // DESCRIPTION: Shows curated top 3 Pakistani tourist highlights.
            // 🎓 TO HIDE THIS SECTION:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Top Picks', style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: DummyData.popularDestinations.length > 3 ? 3 : DummyData.popularDestinations.length,
                itemBuilder: (context, index) {
                  final dest = DummyData.popularDestinations[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: dest);
                    },
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            UnsplashImage(
                              query: dest['name']!,
                              fallbackUrl: dest['image'],
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    dest['name']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        dest['rating'].toString(),
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // ======================================================
            // 🔴 [END] SECTION: Top Picks Horizontal Carousel
            // ======================================================

            const SizedBox(height: 32),

            // ======================================================
            // 🔴 [START] BUTTON ROW: Book a Trip & Messages / AI Chat
            // DESCRIPTION: Quick action buttons for booking and AI conversation.
            // 🎓 TO HIDE THESE BUTTONS:
            //    - Set AppConfig.enableBooking = false; to hide "Book a Trip"
            //    - Set AppConfig.enableAiChat = false; to hide "Messages"
            //    - Or comment out lines from [START] to [END] of this block.
            // ======================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  // Book a Trip Button
                  if (AppConfig.enableBooking)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingScreen()));
                        },
                        icon: const Icon(Icons.flight_takeoff),
                        label: const Text('Book a Trip'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  if (AppConfig.enableBooking && AppConfig.enableAiChat) const SizedBox(width: 16),

                  // Messages / AI Chat Button
                  if (AppConfig.enableAiChat)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('Messages'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ======================================================
            // 🔴 [END] BUTTON ROW: Book a Trip & Messages
            // ======================================================

            const SizedBox(height: 32),

            // ======================================================
            // 🔴 [START] SECTION: Trips & Tours Horizontal Cards List
            // DESCRIPTION: Cards list with "View All" link navigating to TripsScreen.
            // 🎓 TO HIDE THIS SECTION:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trips & Tours', style: Theme.of(context).textTheme.headlineMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TripsScreen()));
                    },
                    child: const Text('View All', style: TextStyle(color: AppTheme.accentTeal)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: DummyData.popularDestinations.length,
                itemBuilder: (context, index) {
                  final dest = DummyData.popularDestinations[index];
                  return DestinationCard(
                    destination: dest,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: dest);
                    },
                    height: 200,
                  );
                },
              ),
            ),
            // ======================================================
            // 🔴 [END] SECTION: Trips & Tours Horizontal Cards List
            // ======================================================

            const SizedBox(height: 32),

            // ======================================================
            // 🔴 [START] SECTION: Popular Destinations Large Cards
            // DESCRIPTION: Full-width destination preview cards with price & rating.
            // 🎓 TO HIDE THIS SECTION:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Destinations', style: Theme.of(context).textTheme.headlineMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TripsScreen()));
                    },
                    child: const Text('See All', style: TextStyle(color: AppTheme.accentTeal)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 320,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: DummyData.popularDestinations.length,
                itemBuilder: (context, index) {
                  final dest = DummyData.popularDestinations[index];
                  return DestinationCard(
                    destination: dest,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: dest);
                    },
                  );
                },
              ),
            ),
            // ======================================================
            // 🔴 [END] SECTION: Popular Destinations Large Cards
            // ======================================================

            const SizedBox(height: 32),

            // ======================================================
            // 🔴 [START] SECTION: Featured Collections
            // DESCRIPTION: Category cards for scenic Pakistani regions.
            // 🎓 TO HIDE THIS SECTION:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Featured Collections', style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: DummyData.featuredPlaces.length,
                itemBuilder: (context, index) {
                  final place = DummyData.featuredPlaces[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: place);
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            UnsplashImage(
                              query: place['name']!,
                              fallbackUrl: place['image'],
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                              child: Center(
                                child: Text(
                                  place['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // ======================================================
            // 🔴 [END] SECTION: Featured Collections
            // ======================================================

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
