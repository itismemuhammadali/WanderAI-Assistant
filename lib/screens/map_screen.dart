// ============================================================================
// SCREEN: Interactive Map Screen
// FILE: lib/screens/map_screen.dart
// PURPOSE: OpenStreetMap / FlutterMap view of Pakistan with real-time GPS location,
//          dual route polylines (Fastest KKH vs Scenic Naran Babusar), attraction pins,
//          and quick trip planning bottom sheet.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Map Screen bottom bar se hata do!"
//    - In lib/screens/main_shell.dart, comment out the Map item in navItems.
// 2. TEACHER: "Fast vs Scenic route switcher hatao, sirf ek route dikhao!"
//    - Set _selectedRoute = 'fast'; and comment out the route switcher toggle widget.
// 3. TEACHER: "Map pins/markers change karo ya add karo!"
//    - Look at _fastestRoutePoints (Line 46) or attractions list (Line 120).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../core/app_routes.dart';
import '../core/app_config.dart';
import '../widgets/custom_app_bar.dart';
import 'trip_preferences_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = const LatLng(33.6844, 73.0479);
  String _selectedRoute = 'fast'; // 'fast' or 'scenic'
  final bool _showAttractions = true;

  // Polyline for Fastest Route (Islamabad to Hunza via KKH Direct)
  final List<LatLng> _fastestRoutePoints = const [
    LatLng(33.6844, 73.0479), // Islamabad
    LatLng(34.1688, 73.2215), // Abbottabad
    LatLng(34.3333, 73.2000), // Mansehra
    LatLng(34.9272, 72.8767), // Besham
    LatLng(35.2917, 73.2144), // Dassu
    LatLng(35.4206, 74.0967), // Chilas
    LatLng(35.9208, 74.3144), // Gilgit
    LatLng(36.3167, 74.6667), // Hunza
  ];

  // Polyline for Scenic Route (Islamabad to Hunza via Naran & Babusar Pass)
  final List<LatLng> _scenicRoutePoints = const [
    LatLng(33.6844, 73.0479), // Islamabad
    LatLng(34.1688, 73.2215), // Abbottabad
    LatLng(34.5497, 73.3544), // Balakot
    LatLng(34.6292, 73.4739), // Shogran
    LatLng(34.9085, 73.6528), // Naran
    LatLng(34.8767, 73.6931), // Saif-ul-Malook Lake
    LatLng(35.0333, 73.7833), // Batakundi
    LatLng(35.0833, 73.9167), // Lulusar Lake & Waterfall
    LatLng(35.1481, 74.0483), // Babusar Top Pass (4173m)
    LatLng(35.4206, 74.0967), // Chilas
    LatLng(35.9208, 74.3144), // Gilgit
    LatLng(36.3167, 74.6667), // Hunza (Karimabad)
  ];

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        await _getCurrentLocation();
      }
    } catch (e) {
      debugPrint('Location init error: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      ).timeout(const Duration(seconds: 15));

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
      }
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  void _centerOnLocation() {
    if (_currentLocation != const LatLng(33.6844, 73.0479)) {
      _mapController.move(_currentLocation, 12);
    }
  }

  void _centerOnRoute() {
    _mapController.move(const LatLng(34.9085, 73.8500), 7.2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Explore Map & Dual Routes',
        actions: [
          IconButton(
            tooltip: 'Center on Route',
            icon: const Icon(Icons.alt_route),
            onPressed: _centerOnRoute,
          ),
          IconButton(
            tooltip: 'My Location',
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(34.8000, 73.7000),
              initialZoom: 7,
              onMapReady: () {
                debugPrint('Map is ready');
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.travel_assistant',
              ),
              // Dual Route Polyline Layer
              PolylineLayer(
                polylines: [
                  // Scenic Route Polyline
                  Polyline(
                    points: _scenicRoutePoints,
                    strokeWidth: _selectedRoute == 'scenic' ? 5.5 : 3.0,
                    color: _selectedRoute == 'scenic'
                        ? const Color(0xFFF59E0B) // Vibrant Amber
                        : Colors.orange.withOpacity(0.35),
                  ),
                  // Fastest Route Polyline
                  Polyline(
                    points: _fastestRoutePoints,
                    strokeWidth: _selectedRoute == 'fast' ? 5.5 : 3.0,
                    color: _selectedRoute == 'fast'
                        ? const Color(0xFF0D9488) // Vibrant Teal
                        : Colors.teal.withOpacity(0.35),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Origin Marker (Islamabad)
                  Marker(
                    point: const LatLng(33.6844, 73.0479),
                    width: 44,
                    height: 44,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: const Icon(Icons.trip_origin, color: Colors.white, size: 26),
                    ),
                  ),
                  // Destination Marker (Hunza)
                  Marker(
                    point: const LatLng(36.3167, 74.6667),
                    width: 48,
                    height: 48,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: const Icon(Icons.flag, color: Colors.white, size: 28),
                    ),
                  ),
                  // Corridor Attractions Markers (Waterfalls, Lakes, Passes, Forts)
                  if (_showAttractions)
                    ...DummyData.routeAttractions.map((att) {
                      final lat = att['latitude'] as double? ?? 34.9085;
                      final lng = att['longitude'] as double? ?? 73.6528;
                      final cat = (att['category'] as String? ?? '').toLowerCase();

                      IconData iconData = Icons.place;
                      Color pinColor = Colors.teal;

                      if (cat.contains('lake') || cat.contains('waterfall')) {
                        iconData = Icons.water;
                        pinColor = const Color(0xFF0284C7); // Sky blue
                      } else if (cat.contains('pass') || cat.contains('mountain')) {
                        iconData = Icons.landscape;
                        pinColor = const Color(0xFFD97706); // Amber
                      } else if (cat.contains('fort') || cat.contains('heritage')) {
                        iconData = Icons.castle;
                        pinColor = const Color(0xFF7C3AED); // Purple
                      }

                      return Marker(
                        point: LatLng(lat, lng),
                        width: 42,
                        height: 42,
                        child: GestureDetector(
                          onTap: () => _showAttractionModal(att),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: pinColor, width: 2.5),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Icon(iconData, color: pinColor, size: 22),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ],
          ),
          // ======================================================
          // 🔴 [START] COMPONENT: Route Toggle Bar at Top (Dual Routes)
          // DESCRIPTION: Toggle buttons to switch between Fastest (KKH) and Scenic (Naran).
          // 🎓 TEACHER SAYS: "Remove the route switcher toggle!"
          //    METHOD 1: Set AppConfig.enableDualRoutes = false; in lib/core/app_config.dart
          //    METHOD 2: Comment out lines from [START] to [END] of this block.
          // ======================================================
          if (AppConfig.enableDualRoutes)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedRoute = 'fast');
                        _centerOnRoute();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedRoute == 'fast' ? const Color(0xFF0D9488) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.speed,
                              size: 18,
                              color: _selectedRoute == 'fast' ? Colors.white : Colors.grey.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Fastest (11h 30m)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: _selectedRoute == 'fast' ? Colors.white : Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedRoute = 'scenic');
                        _centerOnRoute();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedRoute == 'scenic' ? const Color(0xFFF59E0B) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.landscape,
                              size: 18,
                              color: _selectedRoute == 'scenic' ? Colors.white : Colors.grey.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Scenic (Babusar)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: _selectedRoute == 'scenic' ? Colors.white : Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ======================================================
          // 🔴 [END] COMPONENT: Route Toggle Bar at Top
          // ======================================================

          // ======================================================
          // 🔴 [START] CARD: Route Details Floating Bottom Card
          // DESCRIPTION: Bottom summary card showing duration, distance, and action buttons.
          // 🎓 TO HIDE THIS CARD:
          //    Comment out lines from [START] to [END] of this block.
          // ======================================================
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _selectedRoute == 'fast'
                                        ? const Color(0xFF0D9488)
                                        : const Color(0xFFF59E0B),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _selectedRoute == 'fast'
                                        ? 'Fastest Motorway / KKH'
                                        : 'Scenic Mountain Corridor',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedRoute == 'fast'
                                  ? '580 km • 1 stop • Abbottabad & Besham'
                                  : '640 km • 5 scenic stops • Naran & Babusar',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedRoute == 'fast'
                              ? const Color(0xFF0D9488).withValues(alpha: 0.1)
                              : const Color(0xFFF59E0B).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedRoute == 'fast' ? 'Optimal' : 'Scenic Picks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: _selectedRoute == 'fast'
                                ? const Color(0xFF0D9488)
                                : const Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.routeAttractions);
                          },
                          icon: const Icon(Icons.list_alt, size: 18),
                          label: const Text('View All POIs'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TripPreferencesScreen()),
                            );
                          },
                          icon: const Icon(Icons.tune, size: 18),
                          label: const Text('Customize'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ======================================================
          // 🔴 [END] CARD: Route Details Floating Bottom Card
          // ======================================================
        ],
      ),
    );
  }

  void _showAttractionModal(Map<String, dynamic> att) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    att['image'] ?? '',
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 85,
                      height: 85,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.landscape, size: 36, color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.accentTeal.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          att['category'] ?? 'Corridor Attraction',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        att['name'] ?? '',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${att['rating'] ?? 4.8} • ${att['distance'] ?? 'Along Route'}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              att['description'] ?? '',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${att['name']} added to your scenic stopovers!'),
                          backgroundColor: const Color(0xFF0D9488),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_location_alt, size: 18),
                    label: const Text('Add Stop'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}