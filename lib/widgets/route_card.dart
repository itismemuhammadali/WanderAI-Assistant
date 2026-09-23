import 'package:flutter/material.dart';
import '../core/theme.dart';

class RouteCard extends StatelessWidget {
  final Map<String, dynamic> route;
  final bool isSelected;
  final VoidCallback onTap;

  const RouteCard({
    Key? key,
    required this.route,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentTeal.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.accentTeal : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accentTeal : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForType(route['type']),
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppTheme.primaryBlue : AppTheme.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        route['duration'],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.transfer_within_a_station, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '\${route["stops"]} Stops',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              route['price'],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppTheme.accentTeal : AppTheme.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'fast':
        return Icons.flight_takeoff;
      case 'scenic':
        return Icons.directions_railway;
      case 'medium':
      default:
        return Icons.directions_bus;
    }
  }
}
