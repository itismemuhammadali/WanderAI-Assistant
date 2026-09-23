import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/custom_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'booking',
      'title': 'Booking Confirmed',
      'message': 'Your trip to Hunza Valley has been confirmed. Check your email for details.',
      'time': '2 hours ago',
      'isRead': false,
      'icon': Icons.check_circle,
    },
    {
      'id': '2',
      'type': 'reminder',
      'title': 'Trip Reminder',
      'message': 'Your trip to Skardu is in 3 days. Make sure to pack your bags!',
      'time': '1 day ago',
      'isRead': false,
      'icon': Icons.alarm,
    },
    {
      'id': '3',
      'type': 'deal',
      'title': 'Special Deal',
      'message': 'Get 20% off on Swat Valley packages this weekend only!',
      'time': '2 days ago',
      'isRead': true,
      'icon': Icons.local_offer,
    },
    {
      'id': '4',
      'type': 'update',
      'title': 'App Update',
      'message': 'New features available! Check out the updated Explore Map.',
      'time': '1 week ago',
      'isRead': true,
      'icon': Icons.update,
    },
    {
      'id': '5',
      'type': 'message',
      'title': 'New Message',
      'message': 'AI Travel Assistant: Here are some great options for your next adventure!',
      'time': '1 week ago',
      'isRead': true,
      'icon': Icons.chat_bubble,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        showBackButton: true,
        actions: [
          TextButton(
            onPressed: () => _markAllAsRead(),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: AppTheme.textSecondary),
                  const SizedBox(height: 16),
                  Text('No notifications', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                return _buildNotificationTile(notif);
              },
            ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notif) {
    final isRead = notif['isRead'] as bool;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : AppTheme.accentTeal.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? Colors.grey.shade200 : AppTheme.accentTeal.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              notif['icon'] as IconData,
              color: AppTheme.accentTeal,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notif['title'] as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.accentTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notif['message'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  notif['time'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notif in _notifications) {
        notif['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }
}