import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/app_routes.dart';
import '../widgets/custom_app_bar.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    final destination = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Booking Summary', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trip Details', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              _buildSummaryCard(destination),
              const SizedBox(height: 32),
              Text('Traveler Information', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: 'John Doe',
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: 'john.doe@example.com',
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: '+1 234 567 8900',
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 32),
              Text('Special Requests', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Any dietary requirements or accessibility needs?',
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, AppRoutes.bookingConfirmation, arguments: destination);
                    }
                  },
                  child: const Text('Confirm Booking Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic>? destination) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(destination?['image'] ?? 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?q=80&w=2074&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination?['name'] ?? 'Custom Trip',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Route: Balanced Route',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: PKR ${destination?["price"] ?? 55000}',
                  style: const TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
