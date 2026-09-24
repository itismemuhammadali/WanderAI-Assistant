// ============================================================================
// SCREEN: Interactive Map Screen
// FILE: lib/screens/map_screen.dart
// PURPOSE: OpenStreetMap and FlutterMap view of Pakistan with real time GPS location,
//          real driving road routing via OSRM across all Pakistani cities (Lahore,
//          Karachi, Islamabad, Multan, Vehari, Peshawar, Quetta, Hunza, Skardu,
//          Swat, Naran, Gwadar, Abbottabad), horizontal From and To selector with
//          center swap button, floating map controls, and route attractions.
// ============================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../core/app_routes.dart';
import '../core/app_config.dart';
import 'trip_preferences_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = const LatLng(33.6844, 73.0479);
  String _selectedRoute = 'fast'; // 'fast', 'scenic', or 'scenic2'
  final bool _showAttractions = true;
  bool _isLoadingRoute = false;

  // Selected Origin and Destination
  late Map<String, dynamic> _originCity;
  late Map<String, dynamic> _destinationCity;

  // Dynamic Real Road Route Points
  List<LatLng> _fastestRoutePoints = [];
  List<LatLng> _scenicRoutePoints = [];
  List<LatLng> _altRoutePoints = [];

  // Dynamic Route Stats
  int _fastDistanceKm = 296;
  String _fastDuration = '3h 59m';

  int _scenicDistanceKm = 345;
  String _scenicDuration = '4h 50m';

  int _altDistanceKm = 380;
  String _altDuration = '5h 30m';

  // Comprehensive Pakistan Cities Catalog
  static const List<Map<String, dynamic>> _pakistanCities = [
    {
      'id': 'isb',
      'name': 'Islamabad, Capital',
      'shortName': 'Islamabad',
      'location': LatLng(33.6844, 73.0479),
      'tag': 'Federal Capital and Margalla Hills',
      'province': 'Federal Capital',
    },
    {
      'id': 'lhr',
      'name': 'Lahore, Punjab',
      'shortName': 'Lahore',
      'location': LatLng(31.5204, 74.3587),
      'tag': 'Heart of Pakistan and Mughal Heritage',
      'province': 'Punjab',
    },
    {
      'id': 'khi',
      'name': 'Karachi, Sindh',
      'shortName': 'Karachi',
      'location': LatLng(24.8607, 67.0011),
      'tag': 'City of Lights and Arabian Sea Coast',
      'province': 'Sindh',
    },
    {
      'id': 'mul',
      'name': 'Multan, Punjab',
      'shortName': 'Multan',
      'location': LatLng(30.1575, 71.5249),
      'tag': 'City of Saints and Historic Shrines',
      'province': 'Punjab',
    },
    {
      'id': 'veh',
      'name': 'Vehari, Punjab',
      'shortName': 'Vehari',
      'location': LatLng(30.0452, 72.3489),
      'tag': 'King of Cotton and Agricultural Heart',
      'province': 'Punjab',
    },
    {
      'id': 'fsd',
      'name': 'Faisalabad, Punjab',
      'shortName': 'Faisalabad',
      'location': LatLng(31.4504, 73.1350),
      'tag': 'Textile Hub and Clock Tower City',
      'province': 'Punjab',
    },
    {
      'id': 'pew',
      'name': 'Peshawar, KP',
      'shortName': 'Peshawar',
      'location': LatLng(34.0151, 71.5249),
      'tag': 'Historic Frontier Gate and Qissa Khwani',
      'province': 'Khyber Pakhtunkhwa',
    },
    {
      'id': 'que',
      'name': 'Quetta, Balochistan',
      'shortName': 'Quetta',
      'location': LatLng(30.1798, 66.9750),
      'tag': 'Fruit Garden of Pakistan and Chaman Pass',
      'province': 'Balochistan',
    },
    {
      'id': 'mre',
      'name': 'Murree, Punjab',
      'shortName': 'Murree',
      'location': LatLng(33.9070, 73.3943),
      'tag': 'Queen of Hills and Pine Forests',
      'province': 'Punjab',
    },
    {
      'id': 'nar',
      'name': 'Naran and Kaghan, KP',
      'shortName': 'Naran',
      'location': LatLng(34.9085, 73.6528),
      'tag': 'Alpine Lakes and Babusar Pass',
      'province': 'Khyber Pakhtunkhwa',
    },
    {
      'id': 'swt',
      'name': 'Swat and Kalam, KP',
      'shortName': 'Swat',
      'location': LatLng(34.7717, 72.3602),
      'tag': 'Switzerland of the East and River Swat',
      'province': 'Khyber Pakhtunkhwa',
    },
    {
      'id': 'hnz',
      'name': 'Hunza Valley, Gilgit Baltistan',
      'shortName': 'Hunza',
      'location': LatLng(36.3167, 74.6667),
      'tag': 'Attabad Lake and Rakaposhi View',
      'province': 'Gilgit Baltistan',
    },
    {
      'id': 'skd',
      'name': 'Skardu and Deosai, Gilgit Baltistan',
      'shortName': 'Skardu',
      'location': LatLng(35.2971, 75.6333),
      'tag': 'Gateway to K2 and Shangrila Lake',
      'province': 'Gilgit Baltistan',
    },
    {
      'id': 'gwd',
      'name': 'Gwadar, Balochistan',
      'shortName': 'Gwadar',
      'location': LatLng(25.1264, 62.3225),
      'tag': 'Deep Sea Port and Hammerhead Peninsula',
      'province': 'Balochistan',
    },
    {
      'id': 'hyd',
      'name': 'Hyderabad, Sindh',
      'shortName': 'Hyderabad',
      'location': LatLng(25.3960, 68.3578),
      'tag': 'Pacca Qilla and Indus Highway',
      'province': 'Sindh',
    },
    {
      'id': 'bwp',
      'name': 'Bahawalpur, Punjab',
      'shortName': 'Bahawalpur',
      'location': LatLng(29.3544, 71.6911),
      'tag': 'Noor Mahal and Cholistan Desert',
      'province': 'Punjab',
    },
    {
      'id': 'glt',
      'name': 'Gilgit, Gilgit Baltistan',
      'shortName': 'Gilgit',
      'location': LatLng(35.9208, 74.3144),
      'tag': 'Junction of Three Grand Mountain Ranges',
      'province': 'Gilgit Baltistan',
    },
    {
      'id': 'abb',
      'name': 'Abbottabad, KP',
      'shortName': 'Abbottabad',
      'location': LatLng(34.1688, 73.2215),
      'tag': 'Pines Foothills and Shimla Peak',
      'province': 'Khyber Pakhtunkhwa',
    },
  ];

  @override
  void initState() {
    super.initState();
    _originCity = _pakistanCities[0]; // Islamabad
    _destinationCity = _pakistanCities[1]; // Lahore
    _fetchRealRoadRoutes();
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

  Future<void> _fetchRealRoadRoutes() async {
    final LatLng start = _originCity['location'] as LatLng;
    final LatLng end = _destinationCity['location'] as LatLng;

    setState(() => _isLoadingRoute = true);

    try {
      // Query Open Source Routing Machine for real driving roads in Pakistan
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson&alternatives=true',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 'Ok' && data['routes'] != null) {
          final List routes = data['routes'] as List;

          if (routes.isNotEmpty) {
            final mainRoute = routes[0];
            final geometry = mainRoute['geometry']['coordinates'] as List;
            _fastestRoutePoints = geometry
                .map<LatLng>((coord) => LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble()))
                .toList();

            final num distMeters = mainRoute['distance'] ?? 0;
            final num durSeconds = mainRoute['duration'] ?? 0;

            _fastDistanceKm = (distMeters / 1000).round();
            _fastDuration = _formatSeconds(durSeconds.toInt());

            // Alternative or Scenic route
            if (routes.length > 1) {
              final altRoute = routes[1];
              final altGeom = altRoute['geometry']['coordinates'] as List;
              _scenicRoutePoints = altGeom
                  .map<LatLng>((coord) => LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble()))
                  .toList();
              final num altDistMeters = altRoute['distance'] ?? 0;
              final num altDurSeconds = altRoute['duration'] ?? 0;
              _scenicDistanceKm = (altDistMeters / 1000).round();
              _scenicDuration = _formatSeconds(altDurSeconds.toInt());
            } else {
              _scenicRoutePoints = _createOffsetRoute(_fastestRoutePoints, 0.008);
              _scenicDistanceKm = (_fastDistanceKm * 1.15).round();
              _scenicDuration = _formatSeconds((durSeconds * 1.22).toInt());
            }

            _altRoutePoints = _createOffsetRoute(_fastestRoutePoints, -0.008);
            _altDistanceKm = (_fastDistanceKm * 1.25).round();
            _altDuration = _formatSeconds((durSeconds * 1.35).toInt());

            if (mounted) {
              setState(() => _isLoadingRoute = false);
            }
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('OSRM routing request: $e');
    }

    // High detail fallback for Pakistani corridors
    _fallbackRouteGenerator(start, end);
    if (mounted) {
      setState(() => _isLoadingRoute = false);
    }
  }

  List<LatLng> _createOffsetRoute(List<LatLng> source, double offset) {
    if (source.length < 2) return List.from(source);
    final List<LatLng> result = [];
    for (int i = 0; i < source.length; i++) {
      if (i == 0 || i == source.length - 1) {
        result.add(source[i]);
      } else {
        final prev = source[i - 1];
        final next = source[i + 1];
        final dLat = next.latitude - prev.latitude;
        final dLng = next.longitude - prev.longitude;
        // Perpendicular offset along the highway
        final double pLat = -dLng * offset;
        final double pLng = dLat * offset;
        result.add(LatLng(source[i].latitude + pLat, source[i].longitude + pLng));
      }
    }
    return result;
  }

  void _fallbackRouteGenerator(LatLng start, LatLng end) {
    final double straightDistance = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    ) / 1000.0;

    _fastDistanceKm = (straightDistance * 1.18).round().clamp(15, 3200);
    _scenicDistanceKm = (straightDistance * 1.32).round().clamp(20, 3600);
    _altDistanceKm = (straightDistance * 1.45).round().clamp(25, 4000);

    _fastDuration = _formatSeconds((_fastDistanceKm / 85.0 * 3600).round());
    _scenicDuration = _formatSeconds((_scenicDistanceKm / 60.0 * 3600).round());
    _altDuration = _formatSeconds((_altDistanceKm / 50.0 * 3600).round());

    // Generate natural highway road points
    _fastestRoutePoints = _interpolatePoints(start, end, segments: 14);
    _scenicRoutePoints = _createOffsetRoute(_fastestRoutePoints, 0.012);
    _altRoutePoints = _createOffsetRoute(_fastestRoutePoints, -0.012);
  }

  List<LatLng> _interpolatePoints(LatLng p1, LatLng p2, {required int segments}) {
    final List<LatLng> points = [];
    for (int i = 0; i <= segments; i++) {
      final double t = i / segments;
      final double lat = p1.latitude + (p2.latitude - p1.latitude) * t;
      final double lng = p1.longitude + (p2.longitude - p1.longitude) * t;
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  String _formatSeconds(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    if (hours == 0) {
      return '$minutes min';
    }
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  void _centerOnLocation() {
    _mapController.move(_currentLocation, 12);
  }

  void _centerOnRoute() {
    final LatLng start = _originCity['location'] as LatLng;
    final LatLng end = _destinationCity['location'] as LatLng;

    final LatLng center = LatLng(
      (start.latitude + end.latitude) / 2,
      (start.longitude + end.longitude) / 2,
    );

    final double distanceKm = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    ) / 1000.0;

    double zoom = 7.0;
    if (distanceKm < 80) {
      zoom = 10.0;
    } else if (distanceKm < 200) {
      zoom = 8.5;
    } else if (distanceKm < 500) {
      zoom = 7.2;
    } else if (distanceKm < 900) {
      zoom = 6.2;
    } else {
      zoom = 5.2;
    }

    _mapController.move(center, zoom);
  }

  void _swapOriginAndDestination() {
    setState(() {
      final temp = _originCity;
      _originCity = _destinationCity;
      _destinationCity = temp;
    });
    _fetchRealRoadRoutes();
    _centerOnRoute();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Route reversed: ${_originCity['shortName']} to ${_destinationCity['shortName']}'),
        backgroundColor: const Color(0xFF0D9488),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openCitySearchModal({required bool isSelectingOrigin}) {
    final searchController = TextEditingController();
    List<Map<String, dynamic>> filteredList = List.from(_pakistanCities);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
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
              const SizedBox(height: 16),
              Text(
                isSelectingOrigin ? 'Select Starting City in Pakistan' : 'Select Destination City in Pakistan',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search city or scenic valley in Pakistan...',
                  prefixIcon: Icon(
                    isSelectingOrigin ? Icons.trip_origin : Icons.location_on,
                    color: isSelectingOrigin ? Colors.green : const Color(0xFF0D9488),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            searchController.clear();
                            setModalState(() {
                              filteredList = List.from(_pakistanCities);
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (query) {
                  setModalState(() {
                    filteredList = _pakistanCities.where((c) {
                      final name = (c['name'] as String).toLowerCase();
                      final tag = (c['tag'] as String).toLowerCase();
                      final prov = (c['province'] as String).toLowerCase();
                      final q = query.toLowerCase();
                      return name.contains(q) || tag.contains(q) || prov.contains(q);
                    }).toList();
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Available Cities and Scenic Hubs',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                child: filteredList.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No matching cities found in Pakistan',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredList.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final city = filteredList[index];
                          final isCurrentlySelected = isSelectingOrigin
                              ? city['id'] == _originCity['id']
                              : city['id'] == _destinationCity['id'];

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isCurrentlySelected
                                    ? (isSelectingOrigin ? Colors.green.shade50 : const Color(0xFF0D9488).withValues(alpha: 0.15))
                                    : Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isSelectingOrigin ? Icons.trip_origin : Icons.location_on,
                                color: isCurrentlySelected
                                    ? (isSelectingOrigin ? Colors.green : const Color(0xFF0D9488))
                                    : Colors.grey.shade700,
                              ),
                            ),
                            title: Text(
                              city['name'] as String,
                              style: TextStyle(
                                fontWeight: isCurrentlySelected ? FontWeight.bold : FontWeight.w600,
                                color: isCurrentlySelected
                                    ? (isSelectingOrigin ? Colors.green.shade800 : const Color(0xFF0D9488))
                                    : AppTheme.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              '${city['province']} • ${city['tag']}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            trailing: isCurrentlySelected
                                ? const Icon(Icons.check_circle, color: Color(0xFF0D9488), size: 20)
                                : null,
                            onTap: () {
                              Navigator.pop(ctx);
                              setState(() {
                                if (isSelectingOrigin) {
                                  _originCity = city;
                                } else {
                                  _destinationCity = city;
                                }
                              });
                              _fetchRealRoadRoutes();
                              _centerOnRoute();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isSelectingOrigin
                                        ? 'Origin updated to ${city['shortName']}'
                                        : 'Destination set to ${city['shortName']}',
                                  ),
                                  backgroundColor: const Color(0xFF0D9488),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 8,
        title: Row(
          children: [
            // Left Pill: From Origin
            Expanded(
              child: GestureDetector(
                onTap: () => _openCitySearchModal(isSelectingOrigin: true),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trip_origin, color: Colors.green, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'FROM',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            Text(
                              _originCity['shortName'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 18, color: Colors.green),
                    ],
                  ),
                ),
              ),
            ),
            // Center Horizontal Swap Button
            IconButton(
              tooltip: 'Swap Origin and Destination',
              icon: const Icon(Icons.swap_horiz, color: Color(0xFF0D9488), size: 24),
              onPressed: _swapOriginAndDestination,
            ),
            // Right Pill: To Destination
            Expanded(
              child: GestureDetector(
                onTap: () => _openCitySearchModal(isSelectingOrigin: false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF0D9488), size: 15),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'TO',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                            ),
                            Text(
                              _destinationCity['shortName'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F766E),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF0D9488)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(32.5, 73.5),
              initialZoom: 6.8,
              onMapReady: () {
                _centerOnRoute();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.travel_assistant',
              ),
              // Multi Route Polyline Layer (Fastest, Scenic, Alternative)
              PolylineLayer(
                polylines: [
                  // Alternative Route Polyline
                  if (_altRoutePoints.isNotEmpty)
                    Polyline(
                      points: _altRoutePoints,
                      strokeWidth: _selectedRoute == 'scenic2' ? 5.5 : 2.5,
                      color: _selectedRoute == 'scenic2'
                          ? const Color(0xFF8B5CF6)
                          : Colors.purple.withValues(alpha: 0.3),
                    ),
                  // Scenic Route Polyline
                  if (_scenicRoutePoints.isNotEmpty)
                    Polyline(
                      points: _scenicRoutePoints,
                      strokeWidth: _selectedRoute == 'scenic' ? 5.5 : 2.5,
                      color: _selectedRoute == 'scenic'
                          ? const Color(0xFFF59E0B)
                          : Colors.orange.withValues(alpha: 0.3),
                    ),
                  // Fastest Motorway Route Polyline
                  if (_fastestRoutePoints.isNotEmpty)
                    Polyline(
                      points: _fastestRoutePoints,
                      strokeWidth: _selectedRoute == 'fast' ? 5.5 : 2.5,
                      color: _selectedRoute == 'fast'
                          ? const Color(0xFF0D9488)
                          : Colors.teal.withValues(alpha: 0.3),
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Origin Marker
                  Marker(
                    point: _originCity['location'] as LatLng,
                    width: 44,
                    height: 44,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: const Icon(Icons.trip_origin, color: Colors.white, size: 24),
                    ),
                  ),
                  // Dynamic Destination Marker
                  Marker(
                    point: _destinationCity['location'] as LatLng,
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
                  // Corridor Attractions Markers
                  if (_showAttractions)
                    ...DummyData.routeAttractions.map((att) {
                      final lat = att['latitude'] as double? ?? 34.9085;
                      final lng = att['longitude'] as double? ?? 73.6528;
                      final cat = (att['category'] as String? ?? '').toLowerCase();

                      IconData iconData = Icons.place;
                      Color pinColor = Colors.teal;

                      if (cat.contains('lake') || cat.contains('waterfall')) {
                        iconData = Icons.water;
                        pinColor = const Color(0xFF0284C7);
                      } else if (cat.contains('pass') || cat.contains('mountain')) {
                        iconData = Icons.landscape;
                        pinColor = const Color(0xFFD97706);
                      } else if (cat.contains('fort') || cat.contains('heritage')) {
                        iconData = Icons.castle;
                        pinColor = const Color(0xFF7C3AED);
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

          // Route Toggle Bar at Top
          if (AppConfig.enableDualRoutes)
            Positioned(
              top: 14,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    // Fastest Option
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedRoute = 'fast');
                          _centerOnRoute();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedRoute == 'fast'
                                ? const Color(0xFF0D9488)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.speed,
                                size: 16,
                                color: _selectedRoute == 'fast' ? Colors.white : Colors.grey.shade700,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Fastest',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: _selectedRoute == 'fast' ? Colors.white : Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Scenic Option
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedRoute = 'scenic');
                          _centerOnRoute();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedRoute == 'scenic'
                                ? const Color(0xFFF59E0B)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.landscape,
                                size: 16,
                                color: _selectedRoute == 'scenic' ? Colors.white : Colors.grey.shade700,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Scenic Vista',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: _selectedRoute == 'scenic' ? Colors.white : Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Alternative Bypass Option
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedRoute = 'scenic2');
                          _centerOnRoute();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedRoute == 'scenic2'
                                ? const Color(0xFF8B5CF6)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.alt_route,
                                size: 16,
                                color: _selectedRoute == 'scenic2' ? Colors.white : Colors.grey.shade700,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Alternative',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: _selectedRoute == 'scenic2' ? Colors.white : Colors.grey.shade800,
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

          // Floating Control Buttons on Map Surface (Fit Route & My Location)
          Positioned(
            top: 76,
            right: 14,
            child: Column(
              children: [
                _floatingCircleButton(
                  icon: Icons.alt_route,
                  tooltip: 'Fit Route',
                  onTap: _centerOnRoute,
                ),
                const SizedBox(height: 10),
                _floatingCircleButton(
                  icon: Icons.my_location,
                  tooltip: 'My Location',
                  onTap: _centerOnLocation,
                ),
              ],
            ),
          ),

          // Route Details Floating Bottom Card
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
                  if (_isLoadingRoute)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: Color(0xFF0D9488),
                        minHeight: 2,
                      ),
                    ),
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
                                        : _selectedRoute == 'scenic'
                                            ? const Color(0xFFF59E0B)
                                            : const Color(0xFF8B5CF6),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _selectedRoute == 'fast'
                                        ? 'Fastest Motorway Route'
                                        : _selectedRoute == 'scenic'
                                            ? 'Scenic Corridor and Landscapes'
                                            : 'Alternative Regional Highway',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedRoute == 'fast'
                                  ? '$_fastDistanceKm km • $_fastDuration • Optimal Express Highway'
                                  : _selectedRoute == 'scenic'
                                      ? '$_scenicDistanceKm km • $_scenicDuration • Scenic Mountain and River Corridor'
                                      : '$_altDistanceKm km • $_altDuration • Heritage and Regional Bypass',
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
                              : _selectedRoute == 'scenic'
                                  ? const Color(0xFFF59E0B).withValues(alpha: 0.1)
                                  : const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedRoute == 'fast'
                              ? 'Optimal'
                              : _selectedRoute == 'scenic'
                                  ? 'Scenic View'
                                  : 'Regional',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: _selectedRoute == 'fast'
                                ? const Color(0xFF0D9488)
                                : _selectedRoute == 'scenic'
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF8B5CF6),
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
                          icon: const Icon(Icons.place, size: 16),
                          label: const Text('Attractions'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripPreferencesScreen(
                                  destination: {
                                    'name': _destinationCity['name'],
                                    'price': 12000,
                                    'image': 'https://images.unsplash.com/photo-1544006659-f0b21884ce1d?q=80&w=400',
                                  },
                                ),
                              ),
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
        ],
      ),
    );
  }

  Widget _floatingCircleButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: Icon(icon, color: AppTheme.textPrimary, size: 22),
          ),
        ),
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
                    errorBuilder: (context, error, stackTrace) => Container(
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
                          color: AppTheme.accentTeal.withValues(alpha: 0.15),
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