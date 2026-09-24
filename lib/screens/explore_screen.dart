// ============================================================================
// SCREEN: Explore Destinations Screen
// FILE: lib/screens/explore_screen.dart
// PURPOSE: Displays a searchable 2 column grid of Pakistan travel destinations.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Grid count change karo (e.g. 1 column ya 3 columns)!"
//    - Line: crossAxisCount: 2 -> Change to 1 or 3!
// 2. TEACHER: "Destination list kahan se load ho rahi hai?"
//    - File: lib/core/dummy_data.dart -> popularDestinations list!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/dummy_data.dart';
import '../core/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/destination_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Explore'),
      // ======================================================
      // 🔴 [START] GRID: Explore Destinations Grid
      // DESCRIPTION: 2 column grid of destination cards.
      // 🎓 TO HIDE THIS GRID:
      //    Comment out lines from [START] to [END] of this block.
      // ======================================================
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: DummyData.popularDestinations.length * 2, // Doubling for dummy grid effect
        itemBuilder: (context, index) {
          final dest = DummyData.popularDestinations[index % DummyData.popularDestinations.length];
          return DestinationCard(
            destination: dest,
            isHorizontal: false,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: dest);
            },
          );
        },
      ),
    );
  }
}
