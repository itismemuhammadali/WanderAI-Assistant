import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../core/dummy_data.dart';

class TripPreferencesScreen extends StatefulWidget {
  const TripPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<TripPreferencesScreen> createState() => _TripPreferencesScreenState();
}

class _TripPreferencesScreenState extends State<TripPreferencesScreen> {
  double _budget = 1500;
  String _selectedCompanion = 'Couple';
  final List<String> _companions = ['Solo', 'Couple', 'Family', 'Friends'];
  final Set<String> _selectedMoods = {'Relaxing', 'Romantic'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Trip Preferences'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Who is traveling?', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _companions.map((comp) {
                final isSelected = _selectedCompanion == comp;
                return ChoiceChip(
                  label: Text(comp),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCompanion = comp);
                  },
                  selectedColor: AppTheme.accentTeal,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Text('Budget (per person)', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('PKR 500'),
                Text('PKR ${_budget.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentTeal, fontSize: 18)),
                const Text('PKR 5000+'),
              ],
            ),
            Slider(
              value: _budget,
              min: 500,
              max: 5000,
              divisions: 45,
              activeColor: AppTheme.accentTeal,
              onChanged: (val) => setState(() => _budget = val),
            ),
            const SizedBox(height: 32),
            Text('Trip Mood', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: DummyData.moods.map((mood) {
                final isSelected = _selectedMoods.contains(mood);
                return FilterChip(
                  label: Text(mood),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) _selectedMoods.add(mood); else _selectedMoods.remove(mood);
                    });
                  },
                  selectedColor: AppTheme.accentTeal.withOpacity(0.2),
                  checkmarkColor: AppTheme.accentTeal,
                );
              }).toList(),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preferences Saved')));
                },
                child: const Text('Save Preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
