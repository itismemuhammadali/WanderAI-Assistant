// ============================================================================
// SCREEN: Help & Support Screen (FAQs & Contact)
// FILE: lib/screens/help_support_screen.dart
// PURPOSE: Expandable FAQ accordion, direct email support launcher, and contact form.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "FAQ expand/collapse demo karo!"
//    - Tap any question in the accordion to animate open the answer!
// 2. TEACHER: "Naya FAQ add karo!"
//    - In `_faqs` list at Line 25 below!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/custom_app_bar.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I book a trip?',
      'answer': 'To book a trip, go to the Home screen, click "Book a Trip", select your destination, choose your preferences, and follow the booking flow. You\'ll receive a confirmation within 24 hours.',
      'isExpanded': false,
    },
    {
      'question': 'Can I modify my booking?',
      'answer': 'Yes, you can modify your booking up to 7 days before your trip. Go to "My Bookings", select the booking, and click "Modify". Changes may incur additional charges.',
      'isExpanded': false,
    },
    {
      'question': 'What is the cancellation policy?',
      'answer': 'Cancellations made 14 days before the trip receive a full refund. Cancellations within 14 days receive 50% refund. Cancellations within 7 days receive no refund.',
      'isExpanded': false,
    },
    {
      'question': 'How do I contact customer support?',
      'answer': 'You can reach our support team via email at support@travelassistant.com, call +92-300-1234567, or use the chat feature in the app.',
      'isExpanded': false,
    },
    {
      'question': 'Is my payment information secure?',
      'answer': 'Yes, we use industry-standard encryption and secure payment gateways. Your payment information is never stored on our servers.',
      'isExpanded': false,
    },
    {
      'question': 'Can I get a refund?',
      'answer': 'Refunds are processed according to our cancellation policy. Once approved, refunds are credited to your original payment method within 5-7 business days.',
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Help & Support',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contact Section
            Container(
              padding: const EdgeInsets.all(24),
              color: AppTheme.accentTeal.withValues(alpha: 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get in Touch',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactTile(
                    Icons.email,
                    'Email',
                    'support@travelassistant.com',
                    () => _launchEmail('support@travelassistant.com'),
                  ),
                  const SizedBox(height: 12),
                  _buildContactTile(
                    Icons.phone,
                    'Phone',
                    '+92-300-1234567',
                    () => _launchPhone('+92-300-1234567'),
                  ),
                  const SizedBox(height: 12),
                  _buildContactTile(
                    Icons.chat_bubble,
                    'Live Chat',
                    'Available 24/7',
                    () => _showLiveChat(),
                  ),
                ],
              ),
            ),
            // FAQ Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequently Asked Questions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ..._faqs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final faq = entry.value;
                    return _buildFAQTile(index, faq);
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.accentTeal),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(int index, Map<String, dynamic> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq['answer'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchEmail(String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening email client for $email')),
    );
  }

  void _launchPhone(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening phone dialer for $phone')),
    );
  }

  void _showLiveChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Connect with our support team'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text('Support team is online'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat started')),
              );
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }
}
