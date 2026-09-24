// ============================================================================
// SCREEN: Customize Your Trip Screen
// FILE: lib/screens/trip_preferences_screen.dart
// PURPOSE: Customize travel companions, traveler count, budget per person,
//          total estimated budget, and vacation moods, then proceed to
//          the interactive trip itinerary.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Budget slider hata do!"
//    - Search for: 🔴 [START] SLIDER: Budget Slider Section
//    - Comment out from [START] to [END] of that block!
// 2. TEACHER: "Itinerary transition kahan ho rahi hai?"
//    - Line: Navigator.push to TripItinerariesScreen inside View Customized Itinerary button!
// ============================================================================

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../core/dummy_data.dart';
import 'trip_itineraries_screen.dart';

class TripPreferencesScreen extends StatefulWidget {
  final Map<String, dynamic>? destination;

  const TripPreferencesScreen({super.key, this.destination});

  @override
  State<TripPreferencesScreen> createState() => _TripPreferencesScreenState();
}

class _TripPreferencesScreenState extends State<TripPreferencesScreen> {
  double _budget = 8000;
  String _selectedCompanion = 'Couple';
  int _travelers = 2;
  final List<String> _companions = ['Solo', 'Couple', 'Family', 'Friends'];
  final Set<String> _selectedMoods = {'Relaxing', 'Adventure'};

  void _onCompanionSelected(String comp) {
    setState(() {
      _selectedCompanion = comp;
      if (comp == 'Solo') {
        _travelers = 1;
      } else if (comp == 'Couple') {
        _travelers = 2;
      } else if (comp == 'Family') {
        if (_travelers < 3) _travelers = 4;
      } else if (comp == 'Friends') {
        if (_travelers < 3) _travelers = 3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final destinationName = widget.destination != null ? widget.destination!['name'] : 'Pakistan Tour';
    final int totalBudget = (_budget * _travelers).toInt();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Customize Your Trip'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Destination Header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.place, color: Color(0xFF0D9488), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Destination',
                          style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          destinationName,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Companions Choice Chips
            Text('Who is traveling?', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _companions.map((comp) {
                final isSelected = _selectedCompanion == comp;
                return ChoiceChip(
                  label: Text(comp),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) _onCompanionSelected(comp);
                  },
                  selectedColor: AppTheme.accentTeal,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Number of Travelers Counter (Enabled for Family, Friends, or custom)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Travelers',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedCompanion == 'Solo'
                            ? 'Solo traveler'
                            : _selectedCompanion == 'Couple'
                                ? '2 adults'
                                : 'Members in group',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _travelers > 1
                            ? () {
                                setState(() => _travelers--);
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: const Color(0xFF0D9488),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          '$_travelers',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: _travelers < 20
                            ? () {
                                setState(() => _travelers++);
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color(0xFF0D9488),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ======================================================
            // 🔴 [START] SLIDER: Budget Slider Section
            // DESCRIPTION: Interactive per person budget slider from PKR 3,000 to PKR 20,000.
            // 🎓 TO HIDE THIS SLIDER:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Budget (per person)', style: Theme.of(context).textTheme.headlineMedium),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PKR ${_budget.toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488), fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PKR 3,000', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text('PKR 20,000', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            Slider(
              value: _budget,
              min: 3000,
              max: 20000,
              divisions: 17,
              activeColor: AppTheme.accentTeal,
              onChanged: (val) => setState(() => _budget = val),
            ),
            // ======================================================
            // 🔴 [END] SLIDER: Budget Slider Section
            // ======================================================
            const SizedBox(height: 12),

            // Total Budget Calculation Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_wallet, color: Colors.amber, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Total Trip Budget',
                          style: TextStyle(fontSize: 12, color: Colors.brown, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'PKR $totalBudget',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$_travelers × ${_budget.toInt()}',
                    style: TextStyle(fontSize: 12, color: Colors.brown.shade400, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Trip Mood Chips
            Text('Trip Mood', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 14),
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
                      if (selected) {
                        _selectedMoods.add(mood);
                      } else {
                        _selectedMoods.remove(mood);
                      }
                    });
                  },
                  selectedColor: AppTheme.accentTeal.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.accentTeal,
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            // ======================================================
            // 🔴 [START] BUTTON: View Customized Itinerary Button
            // DESCRIPTION: Passes traveler settings to TripItinerariesScreen.
            // 🎓 TO HIDE THIS BUTTON:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final target = widget.destination ?? DummyData.popularDestinations.first;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripItinerariesScreen(
                        destination: target,
                        tripType: _selectedCompanion,
                        travelers: _travelers,
                        travelMode: 'SUV / Private Car',
                        accommodation: 'Standard 4 Star',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.map, size: 20),
                label: const Text('View Customized Itinerary'),
              ),
            ),
            // ======================================================
            // 🔴 [END] BUTTON: View Customized Itinerary Button
            // ======================================================
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
