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
  String? _selectedDestination;
  String _tripType = 'solo';
  int _travelers = 2;
  String _travelMode = 'car';
  String _accommodation = 'hotel';
  int _budget = 50000;
  String _searchQuery = '';
  String _region = 'all';
  List<String> _selectedActivities = [];
  String _duration = 'all';
  String _rating = 'all';

  final List<String> _tripTypes = ['solo', 'couple', 'family', 'group'];
  final List<String> _travelModes = ['car', 'bus', 'flight'];
  final List<String> _accommodations = ['hotel', 'resort', 'cottage', 'camping'];

  List<Map<String, dynamic>> get _filteredDestinations {
    List<Map<String, dynamic>> dests = [...DummyData.popularDestinations, ...DummyData.featuredPlaces];
    // Region filtering
    if (_region != 'all') {
      dests = dests.where((d) => d['region'] == _region).toList();
    }
    // Search by name
    if (_searchQuery.isNotEmpty) {
      dests = dests.where((dest) => dest['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    // Filter by activities
    if (_selectedActivities.isNotEmpty) {
      dests = dests.where((dest) {
        final tags = (dest['tags'] as List).cast<String>();
        return _selectedActivities.any((a) => tags.contains(a));
      }).toList();
    }
    return dests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
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
                  GestureDetector(
                    onTap: () {
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
                    },
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Search destinations...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: const Icon(Icons.tune),
                        filled: true,
                        fillColor: AppTheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Destination', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  ..._filteredDestinations.map((dest) => _buildDestinationTile(dest)),
                  const SizedBox(height: 24),
                  Text('Trip Type', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _tripTypes.map((type) => _buildOptionChip(type, _tripType, () => setState(() => _tripType = type), _getTripTypeLabel)).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text('Travelers', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  _buildCounter(),
                  const SizedBox(height: 24),
                  Text('Travel Mode', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _travelModes.map((mode) => _buildOptionChip(mode, _travelMode, () => setState(() => _travelMode = mode), _getTravelModeLabel)).toList(),
                  ),
                  const SizedBox(height: 24),
Text('Accommodation', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _accommodations.map((acc) => _buildOptionChip(acc, _accommodation, () => setState(() => _accommodation = acc), _getAccommodationLabel)).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Budget filter removed
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 16),
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
          color: isSelected ? AppTheme.accentTeal : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label(value),
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCounter() {
    return Row(
      children: [
        IconButton(
          onPressed: _travelers > 1 ? () => setState(() => _travelers--) : null,
          icon: const Icon(Icons.remove_circle_outline),
          iconSize: 32,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('$_travelers', style: Theme.of(context).textTheme.headlineMedium),
        ),
        IconButton(
          onPressed: _travelers < 20 ? () => setState(() => _travelers++) : null,
          icon: const Icon(Icons.add_circle_outline),
          iconSize: 32,
        ),
      ],
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
        return 'Car';
      case 'bus':
        return 'Bus';
      case 'flight':
        return 'Flight';
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
        return 'Cottage';
      case 'camping':
        return 'Camping';
      default:
        return acc;
    }
  }
}
