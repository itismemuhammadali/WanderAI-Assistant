import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../core/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/destination_card.dart';
import 'filters_screen.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  String _searchQuery = '';
  String _sortBy = 'lowToHigh';

  final List<String> _sortOptions = [
    'lowToHigh',
    'highToLow',
    'popular',
  ];

  List<Map<String, dynamic>> _getFilteredTrips() {
    List<Map<String, dynamic>> trips = [...DummyData.popularDestinations, ...DummyData.featuredPlaces];
    
    if (_searchQuery.isNotEmpty) {
      trips = trips.where((t) => t['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    switch (_sortBy) {
      case 'lowToHigh':
        trips.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
        break;
      case 'highToLow':
        trips.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
        break;
    }

    return trips;
  }

  @override
  Widget build(BuildContext context) {
    final trips = _getFilteredTrips();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Trips & Tours',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.surface,
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
                          onApply: (filters) {},
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Sort by:', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _sortOptions.map((option) {
                            final isSelected = _sortBy == option;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(_getSortLabel(option)),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() => _sortBy = option);
                                },
                                selectedColor: AppTheme.accentTeal.withValues(alpha: 0.2),
                                labelStyle: TextStyle(
                                  color: isSelected ? AppTheme.accentTeal : AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: trips.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppTheme.textSecondary),
                        const SizedBox(height: 16),
                        Text('No trips found', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text('Try adjusting your filters', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DestinationCard(
                          destination: trip,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: trip);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(String option) {
    switch (option) {
      case 'lowToHigh':
        return 'Low to High';
      case 'highToLow':
        return 'High to Low';
      case 'popular':
        return 'Popular';
      default:
        return option;
    }
  }
}