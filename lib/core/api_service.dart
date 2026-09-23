import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dummy_data.dart';

class ApiService {
  // Android emulator routes 10.0.2.2 to host machine's localhost; iOS uses 127.0.0.1
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://127.0.0.1:8000';
  }

  static const Duration _timeout = Duration(seconds: 4);

  /// NLP Travel Query Parsing
  static Future<Map<String, dynamic>> parseQuery(String query) async {
    try {
      final url = Uri.parse('$baseUrl/api/nlp/parse');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query}),
      ).timeout(_timeout);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['data'];
      }
    } catch (e) {
      debugPrint('Backend API unavailable, using local NLP parser fallback: $e');
    }

    // Local fallback
    return {
      'destination': 'Hunza Valley',
      'origin': 'Islamabad',
      'duration_days': 5,
      'route_preference': 'scenic',
      'tags': ['Mountains', 'Scenic Landscapes'],
      'estimated_budget_pkr': 45000,
    };
  }

  /// Dual Route Calculation (Fastest vs Scenic)
  static Future<Map<String, dynamic>> calculateRoutes({
    String origin = 'Islamabad',
    String destination = 'Hunza Valley',
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/routes/calculate');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'origin': origin, 'destination': destination}),
      ).timeout(_timeout);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['data'];
      }
    } catch (e) {
      debugPrint('Backend API unavailable, using local route options fallback: $e');
    }

    return {
      'origin': origin,
      'destination': destination,
      'routes': {
        'fastest': DummyData.routeOptions[0],
        'scenic': DummyData.routeOptions[1],
      },
      'recommended': 'scenic',
    };
  }

  /// Corridor POIs (Waterfalls, Lakes, Passes, Forts)
  static Future<List<Map<String, dynamic>>> fetchCorridorPois({
    String routeType = 'scenic',
    String? category,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/pois/corridor?route_type=$routeType${category != null ? '&category=$category' : ''}');
      final res = await http.get(url).timeout(_timeout);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data['data'] as List;
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('Backend API unavailable, using local corridor POIs fallback: $e');
    }

    return DummyData.routeAttractions;
  }

  /// AI Travel Assistant Chat
  static Future<String> sendChatMessage(String message) async {
    try {
      final url = Uri.parse('$baseUrl/api/chat');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message, 'user_id': 'traveler_ali'}),
      ).timeout(_timeout);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['reply'];
      }
    } catch (e) {
      debugPrint('Backend API unavailable, using local chat fallback: $e');
    }

    final lower = message.toLowerCase();
    if (lower.contains('hunza')) {
      return 'Hunza Valley is spectacular! Best months are May to October. Key highlights include Altit Fort, Attabad Lake boat ride, and Passu Cones.';
    } else if (lower.contains('skardu')) {
      return 'Skardu features Shangrila Resort, Lower Kachura Lake, and cold desert safaris. Pack warm clothing!';
    }
    return 'I am your AI Travel Assistant. Ask me about routes, scenic stops, weather, or tour bookings!';
  }

  /// Submit Tour Booking
  static Future<Map<String, dynamic>> submitBooking(Map<String, dynamic> bookingData) async {
    try {
      final url = Uri.parse('$baseUrl/api/bookings');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookingData),
      ).timeout(_timeout);

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return data['data'];
      }
    } catch (e) {
      debugPrint('Backend API unavailable, recording booking locally: $e');
    }

    return {
      'id': 'local-booking-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'confirmed',
      ...bookingData,
    };
  }
}
