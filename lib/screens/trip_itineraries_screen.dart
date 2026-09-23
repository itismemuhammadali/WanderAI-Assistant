import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'booking_details_screen.dart';

class TripItinerariesScreen extends StatefulWidget {
  final Map<String, dynamic> destination;
  final String tripType;
  final int travelers;
  final String travelMode;
  final String accommodation;

  const TripItinerariesScreen({
    super.key,
    required this.destination,
    required this.tripType,
    required this.travelers,
    required this.travelMode,
    required this.accommodation,
  });

  @override
  State<TripItinerariesScreen> createState() => _TripItinerariesScreenState();
}

class _TripItinerariesScreenState extends State<TripItinerariesScreen> {
  int? _selectedItineraryIndex;

  final List<Map<String, dynamic>> _generateItineraries = [
    {
      'duration': '3 Days',
      'days': 3,
      'price': 45000,
      'description': 'Perfect for a quick getaway',
      'highlights': ['Scenic views', 'Local cuisine', 'Photography spots'],
      'activities': [
        {'day': 'Day 1', 'activities': ['Arrival & acclimate', 'City tour', 'Welcome dinner']},
        {'day': 'Day 2', 'activities': ['Hiking adventure', 'Lakeside picnic', 'Sunset viewing']},
        {'day': 'Day 3', 'activities': ['Local market visit', 'Souvenir shopping', 'Departure']},
      ],
      'hotels': [
        {'name': 'Hotel Aster', 'rating': 4.6, 'price': 8000},
        {'name': 'Grand Palace', 'rating': 4.8, 'price': 12000},
      ],
      'meals': ['Breakfast', 'Lunch', 'Dinner'],
    },
    {
      'duration': '5 Days',
      'days': 5,
      'price': 75000,
      'description': 'Ideal for a balanced experience',
      'highlights': ['Adventure activities', 'Cultural immersion', 'Relaxation time'],
      'activities': [
        {'day': 'Day 1', 'activities': ['Arrival & acclimate', 'City tour', 'Welcome dinner']},
        {'day': 'Day 2', 'activities': ['Mountain hiking', 'Lakeside picnic', 'Sunset viewing']},
        {'day': 'Day 3', 'activities': ['Cultural site visit', 'Local market', 'Traditional meal']},
        {'day': 'Day 4', 'activities': ['Adventure sports', 'Photography tour', 'Bonfire dinner']},
        {'day': 'Day 5', 'activities': ['Leisure morning', 'Last-minute shopping', 'Departure']},
      ],
      'hotels': [
        {'name': 'Hotel Aster', 'rating': 4.6, 'price': 10000},
        {'name': 'Grand Palace', 'rating': 4.8, 'price': 15000},
      ],
      'meals': ['Breakfast', 'Lunch', 'Dinner'],
    },
    {
      'duration': '7 Days',
      'days': 7,
      'price': 120000,
      'description': 'Complete immersion experience',
      'highlights': ['Full exploration', 'Deep cultural experience', 'Multiple destinations'],
      'activities': [
        {'day': 'Day 1', 'activities': ['Arrival & acclimate', 'City tour', 'Welcome dinner']},
        {'day': 'Day 2', 'activities': ['Mountain hiking', 'Lakeside picnic', 'Sunset viewing']},
        {'day': 'Day 3', 'activities': ['Cultural site visit', 'Local market', 'Traditional meal']},
        {'day': 'Day 4', 'activities': ['Adventure sports', 'Photography tour', 'Bonfire dinner']},
        {'day': 'Day 5', 'activities': ['Trekking expedition', 'Nature walk', 'Stargazing']},
        {'day': 'Day 6', 'activities': ['Wellness activities', 'Spa & relaxation', 'Gourmet dinner']},
        {'day': 'Day 7', 'activities': ['Leisure morning', 'Last-minute shopping', 'Departure']},
      ],
      'hotels': [
        {'name': 'Hotel Aster', 'rating': 4.6, 'price': 12000},
        {'name': 'Grand Palace', 'rating': 4.8, 'price': 18000},
      ],
      'meals': ['Breakfast', 'Lunch', 'Dinner'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Itineraries'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Perfect Trip',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'to ${widget.destination['name']}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            ..._generateItineraries.asMap().entries.map((entry) {
              final index = entry.key;
              final itinerary = entry.value;
              final isSelected = _selectedItineraryIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedItineraryIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppTheme.accentTeal : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: isSelected ? AppTheme.accentTeal.withValues(alpha: 0.05) : Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itinerary['duration'],
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                itinerary['description'],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.accentTeal,
                              size: 28,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (itinerary['highlights'] as List<String>).map((highlight) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentTeal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              highlight,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.accentTeal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Price',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'PKR ${itinerary['price']}',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: AppTheme.accentTeal,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () => _showItineraryDetails(context, itinerary),
                            child: const Text('View Details'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedItineraryIndex != null ? _proceedToBooking : null,
                child: const Text('Continue to Booking'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showItineraryDetails(BuildContext context, Map<String, dynamic> itinerary) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Itinerary Details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              Text(
                'Day by Day',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ...(itinerary['activities'] as List<Map<String, dynamic>>).map((dayPlan) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayPlan['day'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...(dayPlan['activities'] as List<String>).map((activity) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check, size: 16, color: AppTheme.accentTeal),
                              const SizedBox(width: 8),
                              Expanded(child: Text(activity)),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),
              Text(
                'Hotel Options',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ...(itinerary['hotels'] as List<Map<String, dynamic>>).map((hotel) {
                return ListTile(
                  leading: const Icon(Icons.hotel, color: AppTheme.accentTeal),
                  title: Text(hotel['name']),
                  subtitle: Text('Rating: ${hotel['rating']}'),
                  trailing: Text(
                    'PKR ${hotel['price']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),
              Text(
                'Included Meals',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ...(itinerary['meals'] as List<String>).map((meal) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.restaurant, size: 16, color: AppTheme.accentTeal),
                      const SizedBox(width: 8),
                      Text(meal),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _proceedToBooking() {
    final selectedItinerary = _generateItineraries[_selectedItineraryIndex!];
    final bookingData = {
      'destination': widget.destination,
      'itinerary': selectedItinerary,
      'tripType': widget.tripType,
      'travelers': widget.travelers,
      'travelMode': widget.travelMode,
      'accommodation': widget.accommodation,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(destination: widget.destination),
        settings: RouteSettings(arguments: bookingData),
      ),
    );
  }
}
