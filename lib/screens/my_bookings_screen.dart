// ============================================================================
// SCREEN: My Bookings Screen (History & Active Trips)
// FILE: lib/screens/my_bookings_screen.dart
// PURPOSE: Displays active, upcoming, and past tour bookings with status badges
//          (Confirmed, In Progress, Completed), cancellation, and invoice download.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Booking status badge ka color change karo!"
//    - Look at `_getStatusColor` method around Line 65.
// 2. TEACHER: "Cancel booking popup demo karo!"
//    - Tap the 'Cancel' button on any active card to show the dialog!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/custom_app_bar.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': '1',
      'destination': 'Hunza Valley',
      'image': 'https://images.unsplash.com/photo-1631558288597-28d8ed273fec?q=80&w=1964&auto=format&fit=crop',
      'startDate': '2024-05-15',
      'endDate': '2024-05-18',
      'status': 'confirmed',
      'price': 45000,
      'travelers': 2,
      'bookingId': 'BK001',
    },
    {
      'id': '2',
      'destination': 'Skardu',
      'image': 'https://images.unsplash.com/photo-1625807908993-a5ffbfbf3205?q=80&w=2070&auto=format&fit=crop',
      'startDate': '2024-06-10',
      'endDate': '2024-06-15',
      'status': 'pending',
      'price': 75000,
      'travelers': 3,
      'bookingId': 'BK002',
    },
    {
      'id': '3',
      'destination': 'Swat Valley',
      'image': 'https://images.unsplash.com/photo-1627896157734-4bcdd61245ee?q=80&w=2070&auto=format&fit=crop',
      'startDate': '2024-04-01',
      'endDate': '2024-04-03',
      'status': 'completed',
      'price': 35000,
      'travelers': 2,
      'bookingId': 'BK003',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Bookings',
        showBackButton: true,
      ),
      body: _bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: AppTheme.textSecondary),
                  const SizedBox(height: 16),
                  Text('No bookings yet', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Start planning your next adventure!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final booking = _bookings[index];
                return _buildBookingCard(booking);
              },
            ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] as String;
    final statusColor = status == 'confirmed'
        ? Colors.green
        : status == 'pending'
            ? Colors.orange
            : Colors.grey;

    return GestureDetector(
      onTap: () => _showBookingDetails(booking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(booking['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          booking['destination'],
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        '${booking['startDate']} to ${booking['endDate']}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        '${booking['travelers']} travelers',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PKR ${booking['price']}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.accentTeal,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'ID: ${booking['bookingId']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
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
                'Booking Details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Destination', booking['destination']),
              _buildDetailRow('Booking ID', booking['bookingId']),
              _buildDetailRow('Status', booking['status'].toString().toUpperCase()),
              _buildDetailRow('Start Date', booking['startDate']),
              _buildDetailRow('End Date', booking['endDate']),
              _buildDetailRow('Travelers', '${booking['travelers']} people'),
              _buildDetailRow('Total Price', 'PKR ${booking['price']}'),
              const SizedBox(height: 24),
              Text(
                'Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Itinerary downloaded')),
                    );
                  },
                  child: const Text('Download Itinerary'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking cancelled')),
                    );
                  },
                  child: const Text('Cancel Booking'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
