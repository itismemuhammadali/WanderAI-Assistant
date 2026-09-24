import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../widgets/custom_app_bar.dart';

// ============================================================================
// SCREEN: Route Attractions Screen
// FILE: lib/screens/route_attractions_screen.dart
// PURPOSE: Displays wayside tourist spots along the travel corridor.
// Filters attractions within 85 km of the active driving route.
// Displays road accessibility badges and practical travel preparation tips.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Route corridor banner hata do!"
//    - Search for: 🔴 [START] BANNER: Route Corridor Information Banner
//    - Comment out or set _filterByRouteCorridor to false!
// 2. TEACHER: "Filter chips hata do!"
//    - Search for: 🔴 [START] CHIPS: Road Accessibility Filter Chips
//    - Comment out that SingleChildScrollView block!
// 3. TEACHER: "Nayi attraction add karo ya distance change karo!"
//    - Open lib/core/dummy_data.dart and edit routeAttractions list!
// ============================================================================

class RouteAttractionsScreen extends StatefulWidget {
  final Map<String, dynamic>? originCity;
  final Map<String, dynamic>? destinationCity;
  final List<LatLng>? routePoints;

  const RouteAttractionsScreen({
    super.key,
    this.originCity,
    this.destinationCity,
    this.routePoints,
  });

  @override
  State<RouteAttractionsScreen> createState() => _RouteAttractionsScreenState();
}

class _RouteAttractionsScreenState extends State<RouteAttractionsScreen> {
  String _selectedAccessibilityFilter = 'All';
  bool _filterByRouteCorridor = true;

  Map<String, dynamic>? _resolvedOrigin;
  Map<String, dynamic>? _resolvedDestination;
  List<LatLng>? _resolvedRoutePoints;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resolvedOrigin == null && _resolvedDestination == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _resolvedOrigin = widget.originCity ?? args?['originCity'] as Map<String, dynamic>?;
      _resolvedDestination = widget.destinationCity ?? args?['destinationCity'] as Map<String, dynamic>?;
      _resolvedRoutePoints = widget.routePoints ?? args?['routePoints'] as List<LatLng>?;
    }
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180.0;
    final dLon = (lon2 - lon1) * math.pi / 180.0;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180.0) *
            math.cos(lat2 * math.pi / 180.0) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _minDistanceToRoute(Map<String, dynamic> att, List<LatLng> points) {
    final attLat = (att['latitude'] as num?)?.toDouble() ?? 0.0;
    final attLng = (att['longitude'] as num?)?.toDouble() ?? 0.0;

    if (points.isEmpty) return double.infinity;

    double minDist = double.infinity;
    final int step = (points.length / 80).ceil().clamp(1, points.length);

    for (int i = 0; i < points.length; i += step) {
      final p = points[i];
      final d = _haversineKm(p.latitude, p.longitude, attLat, attLng);
      if (d < minDist) {
        minDist = d;
      }
    }
    return minDist;
  }

  double _distanceFromOrigin(Map<String, dynamic> att, LatLng? origin) {
    if (origin == null) return 0.0;
    final attLat = (att['latitude'] as num?)?.toDouble() ?? 0.0;
    final attLng = (att['longitude'] as num?)?.toDouble() ?? 0.0;
    return _haversineKm(origin.latitude, origin.longitude, attLat, attLng);
  }

  List<Map<String, dynamic>> _getProcessedAttractions() {
    final all = List<Map<String, dynamic>>.from(DummyData.routeAttractions);
    final LatLng? originLoc = _resolvedOrigin?['location'] as LatLng?;
    final LatLng? destLoc = _resolvedDestination?['location'] as LatLng?;

    List<LatLng> points = _resolvedRoutePoints ?? [];
    if (points.isEmpty && originLoc != null && destLoc != null) {
      points = [originLoc, destLoc];
    }

    final bool hasActiveRoute = points.isNotEmpty;

    // Filter by corridor if route exists and corridor filter is enabled
    List<Map<String, dynamic>> filtered = all.where((att) {
      if (hasActiveRoute && _filterByRouteCorridor) {
        final distToRoute = _minDistanceToRoute(att, points);
        // Maximum corridor radius is 85 km from the active highway
        if (distToRoute > 85.0) {
          return false;
        }
      }

      if (_selectedAccessibilityFilter != 'All') {
        final acc = (att['accessibility'] as String? ?? '').toLowerCase();
        if (_selectedAccessibilityFilter == 'Direct Road' && !acc.contains('direct')) {
          return false;
        }
        if (_selectedAccessibilityFilter == '4x4 Jeep' && !acc.contains('jeep')) {
          return false;
        }
        if (_selectedAccessibilityFilter == 'Hike Required' &&
            !acc.contains('hike') &&
            !acc.contains('walk')) {
          return false;
        }
      }

      return true;
    }).toList();

    // If corridor filter yielded no results, return all for this accessibility filter
    if (filtered.isEmpty && _filterByRouteCorridor) {
      filtered = all.where((att) {
        if (_selectedAccessibilityFilter != 'All') {
          final acc = (att['accessibility'] as String? ?? '').toLowerCase();
          if (_selectedAccessibilityFilter == 'Direct Road' && !acc.contains('direct')) {
            return false;
          }
          if (_selectedAccessibilityFilter == '4x4 Jeep' && !acc.contains('jeep')) {
            return false;
          }
          if (_selectedAccessibilityFilter == 'Hike Required' &&
              !acc.contains('hike') &&
              !acc.contains('walk')) {
            return false;
          }
        }
        return true;
      }).toList();
    }

    // Sort sequentially along the route starting from origin
    if (originLoc != null) {
      filtered.sort((a, b) {
        final distA = _distanceFromOrigin(a, originLoc);
        final distB = _distanceFromOrigin(b, originLoc);
        return distA.compareTo(distB);
      });
    }

    return filtered;
  }

  Widget _buildAccessibilityBadge(String? accessibility) {
    final acc = accessibility ?? 'Direct Road Access';
    final lower = acc.toLowerCase();

    Color bg;
    Color fg;
    IconData icon;
    String label;

    if (lower.contains('jeep')) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFB45309);
      icon = Icons.terrain;
      label = '4x4 Jeep Required';
    } else if (lower.contains('hike') || lower.contains('walk')) {
      bg = const Color(0xFFF3E8FF);
      fg = const Color(0xFF7E22CE);
      icon = Icons.hiking;
      label = 'Moderate Hike Required';
    } else {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF15803D);
      icon = Icons.directions_car;
      label = 'Direct Road Access';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(Map<String, dynamic> attraction) {
    final imageUrl = attraction['image'] as String? ?? '';
    final name = attraction['name'] as String? ?? 'Attraction';
    final category = attraction['category'] as String? ?? '';

    IconData fallbackIcon = Icons.landscape;
    if (category.toLowerCase().contains('lake') || category.toLowerCase().contains('water')) {
      fallbackIcon = Icons.water;
    } else if (category.toLowerCase().contains('fort') || category.toLowerCase().contains('heritage')) {
      fallbackIcon = Icons.castle;
    }

    return SizedBox(
      height: 190,
      width: double.infinity,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.grey.shade100,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.accentTeal,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0F766E),
                  const Color(0xFF1E293B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(fallbackIcon, size: 44, color: Colors.white70),
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(
                    color: Colors.teal.shade200,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attractions = _getProcessedAttractions();
    final originName = _resolvedOrigin?['shortName'] ?? _resolvedOrigin?['name'] ?? 'Origin';
    final destName = _resolvedDestination?['shortName'] ?? _resolvedDestination?['name'] ?? 'Destination';
    final bool hasRoute = _resolvedOrigin != null && _resolvedDestination != null;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Route Attractions', showBackButton: true),
      body: Column(
        children: [
          // ======================================================
          // 🔴 [START] BANNER: Route Corridor Information Banner
          // DESCRIPTION: Displays active route cities and corridor radius (85 km).
          // 🎓 TO HIDE THIS BANNER:
          //    Comment out lines from [START] to [END] of this block.
          // ======================================================
          if (hasRoute)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDFA),
                border: Border(bottom: BorderSide(color: Colors.teal.shade100)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentTeal.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.alt_route, color: AppTheme.accentTeal, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$originName to $destName Highway Corridor',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F766E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _filterByRouteCorridor
                              ? 'Showing ${attractions.length} spots within 85 km of driving route'
                              : 'Showing all scenic stops across Pakistan',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filterByRouteCorridor = !_filterByRouteCorridor;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      _filterByRouteCorridor ? 'Show All' : 'My Route',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentTeal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // ======================================================
          // 🔴 [END] BANNER: Route Corridor Information Banner
          // ======================================================

          // ======================================================
          // 🔴 [START] CHIPS: Road Accessibility Filter Chips
          // DESCRIPTION: Filters attractions by Direct Road, 4x4 Jeep, or Hike Required.
          // 🎓 TO HIDE THIS CHIPS ROW:
          //    Comment out lines from [START] to [END] of this block.
          // ======================================================
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _buildFilterChip('All', 'All Stops', Icons.grid_view),
                const SizedBox(width: 8),
                _buildFilterChip('Direct Road', 'Direct Road', Icons.directions_car),
                const SizedBox(width: 8),
                _buildFilterChip('4x4 Jeep', '4x4 Jeep', Icons.terrain),
                const SizedBox(width: 8),
                _buildFilterChip('Hike Required', 'Hike or Walk', Icons.hiking),
              ],
            ),
          ),
          // ======================================================
          // 🔴 [END] CHIPS: Road Accessibility Filter Chips
          // ======================================================

          // List of attractions
          Expanded(
            child: attractions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No wayside attractions found for this filter',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedAccessibilityFilter = 'All';
                              _filterByRouteCorridor = false;
                            });
                          },
                          child: const Text('Reset Filters'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: attractions.length,
                    itemBuilder: (context, index) {
                      final attraction = attractions[index];
                      final accessibility = attraction['accessibility'] as String?;
                      final travelTip = attraction['travelTip'] as String?;

                      // ======================================================
                      // 🔴 [START] CARD: Wayside Route Attraction Card
                      // DESCRIPTION: Wayside spot photo, distance from origin, accessibility, travel tip, and action.
                      // 🎓 TO HIDE THIS CARD:
                      //    Comment out lines from [START] to [END] of this block.
                      // ======================================================
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: _buildImage(attraction),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category, Rating and Accessibility Badge
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppTheme.accentTeal.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          attraction['category'] ?? 'Scenic Landmark',
                                          style: const TextStyle(
                                            fontSize: 11,
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
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Name
                                  Text(
                                    attraction['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Distance & Highway Corridor Info
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          attraction['distance'] ?? 'Along route corridor',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Accessibility Badge
                                  _buildAccessibilityBadge(accessibility),
                                  const SizedBox(height: 10),

                                  // Description
                                  Text(
                                    attraction['description'] ?? '',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),

                                  // Travel Tip Box
                                  if (travelTip != null && travelTip.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0FDF4),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: const Color(0xFFBBF7D0)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.lightbulb_outline,
                                            size: 18,
                                            color: Color(0xFF16A34A),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Travel Tip and Preparation',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF15803D),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  travelTip,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1F2937),
                                                    height: 1.35,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 16),

                                  // ======================================================
                                  // 🔴 [START] BUTTON: Include in Itinerary Button
                                  // DESCRIPTION: Appends this stopover to user's active travel itinerary.
                                  // 🎓 TO HIDE THIS BUTTON:
                                  //    Comment out lines from [START] to [END] of this block.
                                  // ======================================================
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${attraction['name']} added to your active travel itinerary!',
                                            ),
                                            backgroundColor: const Color(0xFF0D9488),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add_location_alt, size: 18),
                                      label: const Text('Include in Itinerary'),
                                    ),
                                  ),
                                  // ======================================================
                                  // 🔴 [END] BUTTON: Include in Itinerary Button
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label, IconData icon) {
    final isSelected = _selectedAccessibilityFilter == filterKey;
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 15,
        color: isSelected ? Colors.white : Colors.grey.shade700,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : Colors.grey.shade800,
        ),
      ),
      selected: isSelected,
      selectedColor: AppTheme.accentTeal,
      backgroundColor: Colors.grey.shade100,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedAccessibilityFilter = filterKey;
          });
        }
      },
    );
  }
}
