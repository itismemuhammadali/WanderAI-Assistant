import 'package:flutter/material.dart';
import '../core/profile.dart';
import '../screens/booking_confirmation_screen.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> destination;
  const BookingDetailsScreen({super.key, required this.destination});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _pickupLocationController;
  late TextEditingController _pickupDateController;
  late TextEditingController _durationController;
  DateTime? _pickupDate;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: UserProfile.fullName);
    _phoneController = TextEditingController(text: UserProfile.phone);
    _emergencyPhoneController = TextEditingController(text: UserProfile.emergencyPhone);
    _pickupLocationController = TextEditingController(text: UserProfile.pickupLocation);
    _pickupDateController = TextEditingController(text: UserProfile.pickupDate);
    _durationController = TextEditingController(text: UserProfile.duration);
    _pickupDate = DateTime.tryParse(UserProfile.pickupDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emergencyPhoneController.dispose();
    _pickupLocationController.dispose();
    _pickupDateController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: now, firstDate: now, lastDate: DateTime(now.year + 2));
    if (picked != null) {
      setState(() {
        _pickupDate = picked;
        _pickupDateController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _continue() {
    if (_formKey.currentState?.validate() ?? false) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final bookingDetails = {
        'destination': widget.destination,
        'itinerary': args?['itinerary'],
        'tripType': args?['tripType'],
        'travelers': args?['travelers'],
        'travelMode': args?['travelMode'],
        'accommodation': args?['accommodation'],
        'fullName': _nameController.text,
        'phone': _phoneController.text,
        'emergencyPhone': _emergencyPhoneController.text,
        'pickupDate': _pickupDate?.toIso8601String() ?? _pickupDateController.text,
        'pickupLocation': _pickupLocationController.text,
        'duration': _durationController.text,
      };
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => const BookingConfirmationScreen(),
        settings: RouteSettings(arguments: bookingDetails),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.destination['name']), leading: BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Enter your details to confirm booking', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                readOnly: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                readOnly: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emergencyPhoneController,
                decoration: const InputDecoration(labelText: 'Emergency Phone'),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _pickupDateController,
                    decoration: const InputDecoration(labelText: 'Pickup Date'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pickupLocationController,
                decoration: const InputDecoration(labelText: 'Pickup Location'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Trip Duration'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _continue,
                child: const Text('Continue to Confirmation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
