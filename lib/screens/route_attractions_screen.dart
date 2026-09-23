// ============================================================================
// SCREEN: Route Attractions Screen
// FILE: lib/screens/route_attractions_screen.dart
// PURPOSE: Displays wayside tourist spots along the travel highway (e.g. Taxila,
//          Rohtas Fort, Katas Raj, Babusar Pass, Rakaposhi viewpoint).
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Route Attractions screen hatao!"
//    - Remove the navigation call from MapScreen or DestinationDetailScreen.
// 2. TEACHER: "Nayi attraction add karo ya distance change karo!"
//    - In lib/core/dummy_data.dart -> `routeAttractions` list!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../widgets/custom_app_bar.dart';

class RouteAttractionsScreen extends StatelessWidget {
  const RouteAttractionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Route Attractions', showBackButton: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: DummyData.routeAttractions.length,
        itemBuilder: (context, index) {
          final attraction = DummyData.routeAttractions[index];

          // ======================================================
          // 🔴 [START] CARD: Wayside Route Attraction Card
          // DESCRIPTION: Displays photo, category badge, rating, distance along highway, and description.
          // 🎓 TO HIDE THIS CARD:
          //    Comment out lines from [START] to [END] of this block.
          // ======================================================
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    attraction['image']!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.accentTeal.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                attraction['category'] ?? 'Scenic Landmark',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${attraction['rating'] ?? 4.8}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          attraction['name']!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              attraction['distance'] ?? 'Along route corridor',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          attraction['description']!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
                        ),
                        const SizedBox(height: 14),

                        // ======================================================
                        // 🔴 [START] BUTTON: Include In Itinerary Button
                        // DESCRIPTION: Appends this wayside scenic spot to the traveler's route plan.
                        // 🎓 TO HIDE THIS BUTTON:
                        //    Comment out lines from [START] to [END] of this block.
                        // ======================================================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${attraction['name']} added to your active travel itinerary!'),
                                  backgroundColor: const Color(0xFF0D9488),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_location_alt, size: 18),
                            label: const Text('Include in Itinerary'),
                          ),
                        ),
                        // ======================================================
                        // 🔴 [END] BUTTON: Include In Itinerary Button
                        // ======================================================
                      ],
                    ),
                  ),
              ],
            ),
          );
          // ======================================================
          // 🔴 [END] CARD: Wayside Route Attraction Card
          // ======================================================
        },
      ),
    );
  }
}
