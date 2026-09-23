// ============================================================================
// SCREEN: Trip Booking Screen
// FILE: lib/screens/booking_screen.dart
// PURPOSE: Allows users to configure custom trip preferences (Destination, Trip Type,
//          Number of Travelers, Transport Mode, Accommodation, Budget).
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// To remove or hide ANY component on this screen, find its conspicuous
// 🔴 [START] and 🔴 [END] comment banners below. Each banner gives you
// exact instructions on how to comment it out or toggle it!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../widgets/custom_app_bar.dart';
import 'filters_screen.dart';
import 'trip_itineraries_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedDestination;
  String _tripType = 'solo';
  int _travelers = 2;
  String _travelMode = 'car';
  String _accommodation = 'hotel';
  String _searchQuery = '';
  String _region = 'all';
  List<String> _selectedActivities = [];
  String _duration = 'all';
  String _rating = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<String> _tripTypes = ['solo', 'couple', 'family', 'group'];
  final List<String> _travelModes = ['car', 'bus', 'flight'];
  final List<String> _accommodations = ['hotel', 'resort', 'cottage', 'camping'];

  List<Map<String, dynamic>> get _allDestinations {
    return [...DummyData.popularDestinations, ...DummyData.featuredPlaces];
  }

  List<Map<String, dynamic>> get _filteredDestinations {
    List<Map<String, dynamic>> dests = _allDestinations;
    if (_region != 'all') {
      dests = dests.where((d) => d['region'] == _region).toList();
    }
    if (_searchQuery.isNotEmpty) {
      dests = dests.where((dest) => dest['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    if (_selectedActivities.isNotEmpty) {
      dests = dests.where((dest) {
        final tags = (dest['tags'] as List).cast<String>();
        return _selectedActivities.any((a) => tags.contains(a));
      }).toList();
    }
    return dests;
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => FiltersScreen(
          currentFilters: {
            'region': _region,
            'duration': _duration,
            'activities': _selectedActivities,
            'rating': _rating,
          },
          onApply: (filters) {
            setState(() {
              _region = filters['region'] ?? 'all';
              _duration = filters['duration'] ?? 'all';
              _selectedActivities = List<String>.from(filters['activities'] ?? []);
              _rating = filters['rating'] ?? 'all';
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _openAllDestinationsModal() {
    final modalSearchController = TextEditingController();
    List<Map<String, dynamic>> modalList = List.from(_allDestinations);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Destinations',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${modalList.length} places',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: modalSearchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search city or valley in Pakistan...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0D9488)),
                  suffixIcon: modalSearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            modalSearchController.clear();
                            setModalState(() {
                              modalList = List.from(_allDestinations);
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
                onChanged: (q) {
                  setModalState(() {
                    modalList = _allDestinations.where((d) {
                      final name = d['name'].toString().toLowerCase();
                      final query = q.toLowerCase();
                      return name.contains(query);
                    }).toList();
                  });
                },
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: modalList.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text('No destinations match your search', style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: modalList.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final dest = modalList[index];
                          final isSelected = _selectedDestination == dest['id'];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                dest['image'] ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.landscape, color: Colors.teal),
                                ),
                              ),
                            ),
                            title: Text(
                              dest['name'] ?? '',
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected ? const Color(0xFF0D9488) : AppTheme.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              '${dest['distance'] ?? 'Tour'} • PKR ${dest['price'] ?? 45000}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle, color: Color(0xFF0D9488))
                                : null,
                            onTap: () {
                              Navigator.pop(ctx);
                              setState(() {
                                _selectedDestination = dest['id'];
                              });
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
      appBar: const CustomAppBar(
        title: 'Book a Trip',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================================================
                  // 🔴 [START] INPUT: Interactive Search Bar & Filters
                  // DESCRIPTION: Active text search with dedicated filter button.
                  // ======================================================
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search destinations...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_searchQuery.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.tune),
                            tooltip: 'Filters',
                            onPressed: _openFilters,
                          ),
                        ],
                      ),
                      filled: true,
                      fillColor: AppTheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  // ======================================================
                  // 🔴 [END] INPUT: Interactive Search Bar & Filters
                  // ======================================================
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================================================
                  // 🔴 [START] SECTION: Destination Selection Tiles
                  // DESCRIPTION: Top 4 destinations with "View All" modal launcher.
                  // ======================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Destination', style: Theme.of(context).textTheme.headlineMedium),
                      TextButton(
                        onPressed: _openAllDestinationsModal,
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: AppTheme.accentTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_filteredDestinations.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No destinations found for "$_searchQuery"',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._filteredDestinations.take(4).map((dest) => _buildDestinationTile(dest)),
                  // ======================================================
                  // 🔴 [END] SECTION: Destination Selection Tiles
                  // ======================================================

                  const SizedBox(height: 24),

                  // ======================================================
                  // 🔴 [START] COMPONENT: Trip Type Option Chips
                  // DESCRIPTION: Selection chips for Solo, Couple, Family, Group.
                  // 🎓 TO HIDE THIS COMPONENT:
                  //    Comment out lines from [START] to [END] of this block.
                  // ======================================================
                  Text('Trip Type', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _tripTypes
                        .map((type) => _buildOptionChip(
                              type,
                              _tripType,
                              () => setState(() => _tripType = type),
                              _getTripTypeLabel,
                            ))
                        .toList(),
                  ),
                  // ======================================================
                  // 🔴 [END] COMPONENT: Trip Type Option Chips
                  // ======================================================

                  const SizedBox(height: 24),

                  // ======================================================
                  // 🔴 [START] COMPONENT: Travelers Counter (+ and - Buttons)
                  // DESCRIPTION: Counter widget to increase or decrease passenger count.
                  // 🎓 TO HIDE THIS COMPONENT:
                  //    Comment out lines from [START] to [END] of this block.
                  // ======================================================
                  Text('Travelers', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  _buildCounter(),
                  // ======================================================
                  // 🔴 [END] COMPONENT: Travelers Counter
                  // ======================================================

                  const SizedBox(height: 24),

                  // ======================================================
                  // 🔴 [START] COMPONENT: Travel Mode Option Chips
                  // DESCRIPTION: Mode of transport (Car, Bus, Flight).
                  // 🎓 TO HIDE THIS COMPONENT:
                  //    Comment out lines from [START] to [END] of this block.
                  // ======================================================
                  Text('Travel Mode', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _travelModes
                        .map((mode) => _buildOptionChip(
                              mode,
                              _travelMode,
                              () => setState(() => _travelMode = mode),
                              _getTravelModeLabel,
                            ))
                        .toList(),
                  ),
                  // ======================================================
                  // 🔴 [END] COMPONENT: Travel Mode Option Chips
                  // ======================================================

                  const SizedBox(height: 24),

                  // ======================================================
                  // 🔴 [START] COMPONENT: Accommodation Option Chips
                  // DESCRIPTION: Lodging type (Hotel, Resort, Cottage, Camping).
                  // 🎓 TO HIDE THIS COMPONENT:
                  //    Comment out lines from [START] to [END] of this block.
                  // ======================================================
                  Text('Accommodation', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _accommodations
                        .map((acc) => _buildOptionChip(
                              acc,
                              _accommodation,
                              () => setState(() => _accommodation = acc),
                              _getAccommodationLabel,
                            ))
                        .toList(),
                  ),
                  // ======================================================
                  // 🔴 [END] COMPONENT: Accommodation Option Chips
                  // ======================================================

                  const SizedBox(height: 32),

                  // ======================================================
                  // 🔴 [START] BUTTON: View Trip Options Submit Button
                  // DESCRIPTION: Navigates to TripItinerariesScreen with configured params.
                  // 🎓 TO HIDE THIS BUTTON:
                  //    Comment out lines from [START] to [END] of this block.
                  // ======================================================
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedDestination != null
                          ? () {
                              final selectedDest = _filteredDestinations.firstWhere(
                                (d) => d['id'] == _selectedDestination,
                                orElse: () => {},
                              );
                              if (selectedDest.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TripItinerariesScreen(
                                      destination: selectedDest,
                                      tripType: _tripType,
                                      travelers: _travelers,
                                      travelMode: _travelMode,
                                      accommodation: _accommodation,
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: const Text('View Trip Options'),
                    ),
                  ),
                  // ======================================================
                  // 🔴 [END] BUTTON: View Trip Options Submit Button
                  // ======================================================

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationTile(Map<String, dynamic> dest) {
    final isSelected = _selectedDestination == dest['id'];
    return GestureDetector(
      onTap: () => setState(() => _selectedDestination = dest['id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.accentTeal : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? AppTheme.accentTeal.withValues(alpha: 0.1) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(dest['image']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dest['name']!, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(dest['distance']!, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppTheme.accentTeal),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionChip(String value, String selected, VoidCallback onTap, String Function(String) label) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentTeal : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accentTeal : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label(value),
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _travelers > 1 ? () => setState(() => _travelers--) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$_travelers',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => _travelers++),
          ),
        ],
      ),
    );
  }

  String _getTripTypeLabel(String type) {
    switch (type) {
      case 'solo':
        return 'Solo';
      case 'couple':
        return 'Couple';
      case 'family':
        return 'Family';
      case 'group':
        return 'Group';
      default:
        return type;
    }
  }

  String _getTravelModeLabel(String mode) {
    switch (mode) {
      case 'car':
        return 'Private Car';
      case 'bus':
        return 'Luxury Bus';
      case 'flight':
        return 'Domestic Flight';
      default:
        return mode;
    }
  }

  String _getAccommodationLabel(String acc) {
    switch (acc) {
      case 'hotel':
        return 'Hotel';
      case 'resort':
        return 'Resort';
      case 'cottage':
        return 'Pine Cottage';
      case 'camping':
        return 'Glamping / Camp';
      default:
        return acc;
    }
  }
}
