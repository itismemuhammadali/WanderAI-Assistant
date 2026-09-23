import 'package:flutter/foundation.dart';
import 'api_service.dart';

class BookingService {
  static bool isDemoDataLoaded = true;

  static final List<Map<String, dynamic>> _demoBookings = [
    {
      'id': 'BK001',
      'destination': 'Hunza Valley',
      'image': 'https://images.unsplash.com/photo-1514558427911-8e293bebf18c?q=80&w=1080&auto=format&fit=crop',
      'startDate': '2026-05-15',
      'endDate': '2026-05-20',
      'status': 'confirmed',
      'price': 45000,
      'travelers': 2,
      'bookingId': 'BK001',
    },
    {
      'id': 'BK002',
      'destination': 'Skardu',
      'image': 'https://images.unsplash.com/photo-1679951124125-50cc4029d727?q=80&w=1080&auto=format&fit=crop',
      'startDate': '2026-06-10',
      'endDate': '2026-06-16',
      'status': 'pending',
      'price': 75000,
      'travelers': 3,
      'bookingId': 'BK002',
    },
    {
      'id': 'BK003',
      'destination': 'Swat Valley',
      'image': 'https://images.unsplash.com/photo-1627896157734-4bcdd61245ee?q=80&w=2070&auto=format&fit=crop',
      'startDate': '2026-04-01',
      'endDate': '2026-04-05',
      'status': 'completed',
      'price': 35000,
      'travelers': 2,
      'bookingId': 'BK003',
    },
  ];

  static List<Map<String, dynamic>> _userBookings = List.from(_demoBookings);

  static List<Map<String, dynamic>> get bookings => _userBookings;

  static void loadDemoData() {
    _userBookings = List.from(_demoBookings);
    isDemoDataLoaded = true;
  }

  static void clearData() {
    _userBookings.clear();
    isDemoDataLoaded = false;
  }

  static Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    final destination = data['destination'] as Map<String, dynamic>? ?? {};
    final itinerary = data['itinerary'] as Map<String, dynamic>? ?? {};
    final destinationName = destination['name'] ?? data['destinationName'] ?? 'Pakistan Tour';
    final imageUrl = destination['image'] ?? 'https://images.unsplash.com/photo-1514558427911-8e293bebf18c?q=80&w=1080&auto=format&fit=crop';
    final price = itinerary['price'] ?? destination['price'] ?? 45000;
    final bookingId = 'BK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final newBooking = {
      'id': bookingId,
      'bookingId': bookingId,
      'destination': destinationName,
      'image': imageUrl,
      'startDate': data['pickupDate'] ?? DateTime.now().toString().substring(0, 10),
      'endDate': 'Flexible',
      'status': 'confirmed',
      'price': price,
      'travelers': data['travelers'] ?? 2,
      'tripType': data['tripType'] ?? 'Custom',
      'travelMode': data['travelMode'] ?? 'car',
      'accommodation': data['accommodation'] ?? 'hotel',
      'fullName': data['fullName'] ?? 'Muhammad Ali',
      'phone': data['phone'] ?? '+923001234567',
      'pickupLocation': data['pickupLocation'] ?? 'Islamabad',
    };

    _userBookings.insert(0, newBooking);

    // Persist to backend Supabase if available
    try {
      await ApiService.submitBooking({
        'destination': destinationName,
        'package_name': itinerary['title'] ?? 'Custom Tour Package',
        'travelers': data['travelers'] ?? 2,
        'travel_date': data['pickupDate'] ?? DateTime.now().toIso8601String(),
        'total_price': price,
        'user_id': 'traveler_ali',
        'status': 'confirmed',
      });
    } catch (e) {
      debugPrint('Booking API error, saved locally: $e');
    }

    return newBooking;
  }
}
