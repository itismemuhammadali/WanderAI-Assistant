// ============================================================================
// SCREEN: Pre-Planned Trip Screen
// FILE: lib/screens/pre_planned_trip_screen.dart
// PURPOSE: Multi-day detailed itinerary breakdown with morning/afternoon/evening
//          schedules, hotel recommendations, and direct booking trigger.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Days schedule ya hotel list change karo!"
//    - Look at lines 20-30 below (`days` and `hotels` lists).
// 2. TEACHER: "Book Now button hatao!"
//    - Comment out bottomNavigationBar ElevatedButton at Line 110!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'booking_details_screen.dart';

class PrePlannedTripScreen extends StatelessWidget {
  final Map<String, dynamic> destination;
  const PrePlannedTripScreen({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> days = [
      {'title': 'Day 1', 'morning': 'Arrive & acclimate', 'afternoon': 'City tour', 'evening': 'Dinner with local cuisine'},
      {'title': 'Day 2', 'morning': 'Hiking', 'afternoon': 'Lakeside picnic', 'evening': 'Stargazing'},
      {'title': 'Day 3', 'morning': 'Museum visit', 'afternoon': 'Shopping', 'evening': 'Free time'},
    ];

    final hotels = [
      {'name': 'Hotel Aster', 'rating': 4.6, 'price': 12000},
      {'name': 'Grand Palace', 'rating': 4.8, 'price': 18000},
    ];

    final meals = ['Breakfast', 'Lunch', 'Dinner'];

    int total = 0;
    hotels.forEach((h) => total += h['price'] as int);
    final totalPrice = total + 5000; // sample additional costs

    return Scaffold(
      appBar: AppBar(title: Text(destination['name']), leading: BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // 🔴 [START] SECTION: Day-by-Day Activity Schedule
            // DESCRIPTION: Morning, afternoon, and evening itinerary breakdown cards.
            // 🎓 TO HIDE THIS SECTION:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            const Text('Day by Day', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...days.map((d) => _DayCard(day: d)).toList(),
            // ======================================================
            // 🔴 [END] SECTION: Day-by-Day Activity Schedule
            // ======================================================

            const SizedBox(height: 16),

            // ======================================================
            // 🔴 [START] SECTION: Hotel Recommendations & Rates
            // DESCRIPTION: Suggested accommodation stays with star ratings and nightly price.
            // 🎓 TO HIDE THIS SECTION:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            const Text('Hotel Suggestions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...hotels.map((h) => _HotelRow(hot: h)).toList(),
            // ======================================================
            // 🔴 [END] SECTION: Hotel Recommendations & Rates
            // ======================================================

            const SizedBox(height: 16),
            const Text('Included Meals', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...meals.map((m) => Text('- $m')).toList(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total trip price', style: TextStyle(fontSize: 18)),
                Text('PKR $totalPrice', style: const TextStyle(fontSize: 18, color: AppTheme.accentTeal, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),

      // ======================================================
      // 🔴 [START] BUTTON: Confirm Booking Bottom Bar Button
      // DESCRIPTION: Opens customer personal details and pickup form for this pre-planned trip.
      // 🎓 TO HIDE THIS BUTTON:
      //    Comment out lines from [START] to [END] of this block.
      // ======================================================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailsScreen(destination: destination)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentTeal),
            child: const Text('Confirm Booking'),
          ),
        ),
      ),
      // ======================================================
      // 🔴 [END] BUTTON: Confirm Booking Bottom Bar Button
      // ======================================================
    );
  }
}

class _DayCard extends StatelessWidget {
  final Map<String, String> day;
  const _DayCard({Key? key, required this.day}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(day['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Morning: ${day['morning']!}'),
            Text('Afternoon: ${day['afternoon']!}'),
            Text('Evening: ${day['evening']!}'),
          ],
        ),
      ),
    );
  }
}

class _HotelRow extends StatelessWidget {
  final Map<String, dynamic> hot;
  const _HotelRow({Key? key, required this.hot}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.hotel, color: AppTheme.accentTeal),
      title: Text('${hot['name']!}'),
      trailing: Text('PKR ${hot['price']}', style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
