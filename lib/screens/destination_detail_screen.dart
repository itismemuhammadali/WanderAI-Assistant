import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'pre_planned_trip_screen.dart';
import 'chat_screen.dart';
import '../core/saved_places_service.dart';
import '../widgets/unsplash_image.dart';

class DestinationDetailScreen extends StatefulWidget {
  const DestinationDetailScreen({super.key});

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  late SavedPlacesService _savedPlacesService;
  late Map<String, dynamic> _destination;

  @override
  void initState() {
    super.initState();
    _savedPlacesService = SavedPlacesService();
    _savedPlacesService.addListener(_onSavedPlacesChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _destination = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  void _onSavedPlacesChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _savedPlacesService.removeListener(_onSavedPlacesChanged);
    super.dispose();
  }

  bool get _isSaved => _savedPlacesService.isPlaceSaved(_destination['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  _savedPlacesService.togglePlace(_destination);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isSaved ? 'Removed from saved places' : 'Added to saved places',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  UnsplashImage(
                    query: _destination['name'],
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          AppTheme.background,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _destination['name'],
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: AppTheme.accentTeal, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  _destination['country'],
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentTeal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(height: 4),
                            Text(
                              _destination['rating'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildInfoChip(context, Icons.account_balance_wallet, 'PKR ${_destination["price"]}'),
                      const SizedBox(width: 16),
                      _buildInfoChip(context, Icons.map_outlined, _destination['distance']),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('About', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Text(
                    _destination['description'],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Text('Tags', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (_destination['tags'] as List<String>).map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade200),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Pre-Planned Trip screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PrePlannedTripScreen(destination: _destination)));
                  },
                  child: const Text('Book Now'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to Chat with pre-filled message
                    final message = 'I am interested in visiting ${_destination["name"]} in ${_destination["country"]}. Can you help me plan my trip?';
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(initialMessage: message, destination: _destination)));
                  },
                  child: const Text('Customize'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.accentTeal),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
