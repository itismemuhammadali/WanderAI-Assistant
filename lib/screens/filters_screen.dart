// ============================================================================
// SCREEN: Filters Screen
// FILE: lib/screens/filters_screen.dart
// PURPOSE: Filter search results by Region (Gilgit-Baltistan, KPK, Punjab, Sindh,
//          Balochistan), Duration, Budget range (PKR), and Activity types.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Filters screen hatao!"
//    - In lib/core/app_config.dart, set: AppConfig.enableFilters = false;
// 2. TEACHER: "Budget slider limits change karo!"
//    - Look at lines 60-80 below (min/max RangeValues).
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';

class FiltersScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;
  final Map<String, dynamic>? currentFilters;

  const FiltersScreen({
    super.key,
    required this.onApply,
    this.currentFilters,
  });

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String _selectedRegion = 'all';
  String _tripDuration = 'all';
  List<String> _selectedActivities = [];
  String _rating = 'all';

  final List<Map<String, String>> _regions = [
    {'value': 'all', 'label': 'All Regions'},
    {'value': 'north', 'label': 'Northern Pakistan'},
    {'value': 'central', 'label': 'Central Pakistan'},
    {'value': 'south', 'label': 'Southern Pakistan'},
    {'value': 'east', 'label': 'Eastern Pakistan'},
    {'value': 'west', 'label': 'Western Pakistan'},
  ];

  // Budget filter removed

  final List<Map<String, String>> _tripDurations = [
    {'value': 'all', 'label': 'Any Duration'},
    {'value': 'weekend', 'label': 'Weekend (2-3 days)'},
    {'value': 'week', 'label': 'Week (4-7 days)'},
    {'value': 'twoWeeks', 'label': '2 Weeks (8-14 days)'},
    {'value': 'month', 'label': 'Month (15+ days)'},
  ];

  final List<Map<String, String>> _activities = [
    {'value': 'mountains', 'label': 'Mountains'},
    {'value': 'lakes', 'label': 'Lakes'},
    {'value': 'rivers', 'label': 'Rivers'},
    {'value': 'forests', 'label': 'Forests'},
    {'value': 'cultural', 'label': 'Cultural'},
    {'value': 'historical', 'label': 'Historical'},
    {'value': 'adventure', 'label': 'Adventure'},
    {'value': 'relaxation', 'label': 'Relaxation'},
  ];

  final List<Map<String, String>> _ratings = [
    {'value': 'all', 'label': 'Any Rating'},
    {'value': '4.5', 'label': '4.5+ Stars'},
    {'value': '4.0', 'label': '4.0+ Stars'},
    {'value': '3.5', 'label': '3.5+ Stars'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.currentFilters != null) {
      _selectedRegion = widget.currentFilters!['region'] ?? 'all';
      _tripDuration = widget.currentFilters!['duration'] ?? 'all';
      _selectedActivities = List<String>.from(widget.currentFilters!['activities'] ?? []);
      _rating = widget.currentFilters!['rating'] ?? 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Region', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _regions.map((r) => _buildFilterChip(r['value']!, _selectedRegion, () => setState(() => _selectedRegion = r['value']!), r['label']!)).toList(),
            ),
            const SizedBox(height: 24),
            // Budget filter removed
            const SizedBox(height: 24),
            Text('Duration', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _tripDurations.map((d) => _buildFilterChip(d['value']!, _tripDuration, () => setState(() => _tripDuration = d['value']!), d['label']!)).toList(),
            ),
            const SizedBox(height: 24),
            Text('Activities', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _activities.map((a) => _buildMultiSelectChip(a['value']!, _selectedActivities, () {
                setState(() {
                  if (_selectedActivities.contains(a['value'])) {
                    _selectedActivities.remove(a['value']);
                  } else {
                    _selectedActivities.add(a['value']!);
                  }
                });
              }, a['label']!)).toList(),
            ),
            const SizedBox(height: 24),
            Text('Minimum Rating', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _ratings.map((r) => _buildFilterChip(r['value']!, _rating, () => setState(() => _rating = r['value']!), r['label']!)).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String selected, VoidCallback onTap, String label) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentTeal : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectChip(String value, List<String> selected, VoidCallback onTap, String label) {
    final isSelected = selected.contains(value);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentTeal : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, color: Colors.white, size: 16),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedRegion = 'all';
      _tripDuration = 'all';
      _selectedActivities = [];
      _rating = 'all';
    });
  }

  void _applyFilters() {
    final filters = {
      'region': _selectedRegion,
      'duration': _tripDuration,
      'activities': _selectedActivities,
      'rating': _rating,
    };
    widget.onApply(filters);
  }
}
