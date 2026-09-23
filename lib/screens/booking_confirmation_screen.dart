// ============================================================================
// SCREEN: Booking Confirmation Screen
// FILE: lib/screens/booking_confirmation_screen.dart
// PURPOSE: Displays booking success tick, unique booking reference ID, summary card,
//          and "Back to Home" navigation button.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Direct Home pe jao confirmation ke baad!"
//    - "Back to Home" button (Line 135) already calls pushNamedAndRemoveUntil to MainShell.
// 2. TEACHER: "Booking ID ka format change karo!"
//    - Look at booking ID generator / display section around Line 45.
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/app_routes.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final destination = args?['destination'] as Map<String, dynamic>? ?? {};
    final itinerary = args?['itinerary'] as Map<String, dynamic>? ?? {};
    final String fullName = args?['fullName'] ?? destination['name'] ?? '';
    final String phone = args?['phone'] ?? '';
    final String emergencyPhone = args?['emergencyPhone'] ?? '';
    final String pickupDate = args?['pickupDate'] ?? '';
    final String pickupLocation = args?['pickupLocation'] ?? '';
    final String duration = args?['duration'] ?? '';
    final int price = itinerary['price'] ?? destination['price'] ?? 55000;
    final String tripDuration = itinerary['duration'] ?? 'Custom';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ======================================================
              // 🔴 [START] COMPONENT: Booking Success Checkmark Icon & Header
              // DESCRIPTION: Large green checkmark indicator confirming booking was received.
              // 🎓 TO HIDE THIS COMPONENT:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: AppTheme.accentTeal,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Booking Received!',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your $tripDuration trip to ${destination["name"] ?? "your destination"} has been tentatively booked.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              // ======================================================
              // 🔴 [END] COMPONENT: Booking Success Checkmark Icon & Header
              // ======================================================

              const SizedBox(height: 32),

              // ======================================================
              // 🔴 [START] CARD: Booking Summary & Traveler Information
              // DESCRIPTION: Displays itinerary name, duration, customer phone, pickup details, and total price.
              // 🎓 TO HIDE THIS CARD:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(24),
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
                        const Text('Trip Details', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text('Destination: ${destination["name"] ?? "N/A"}', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text('Duration: $tripDuration', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        const Text('Traveler Information', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text('Full Name: $fullName', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text('Phone: $phone', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text('Emergency Phone: $emergencyPhone', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text('Pickup Date: $pickupDate', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text('Pickup Location: $pickupLocation', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text('Trip Duration: $duration', style: Theme.of(context).textTheme.bodyMedium),
                        const Divider(height: 32),
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppTheme.accentTeal),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'You will receive a call within 24 hours to confirm your final itinerary and process payment.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Total: PKR $price', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.accentTeal)),
                      ],
                    ),
                  ),
                ),
              ),
              // ======================================================
              // 🔴 [END] CARD: Booking Summary & Traveler Information
              // ======================================================

              const SizedBox(height: 24),

              // ======================================================
              // 🔴 [START] BUTTON: Back to Home Button
              // DESCRIPTION: Resets navigation stack and returns to Main Shell Dashboard.
              // 🎓 TO HIDE THIS BUTTON:
              //    Comment out lines from [START] to [END] of this block.
              // ======================================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.mainShell, (route) => false);
                  },
                  child: const Text('Back to Home'),
                ),
              ),
              // ======================================================
              // 🔴 [END] BUTTON: Back to Home Button
              // ======================================================
            ],
          ),
        ),
      ),
    );
  }
}
