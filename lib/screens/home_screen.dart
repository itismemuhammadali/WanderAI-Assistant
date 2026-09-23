import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../core/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/destination_card.dart';
import '../widgets/unsplash_image.dart';
import 'trips_screen.dart';
import 'chat_screen.dart';
import 'booking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.notificationsScreen);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where to next?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingScreen()));
                },
                child: const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Search destinations...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('Top Picks', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: DummyData.popularDestinations.length > 3 ? 3 : DummyData.popularDestinations.length,
                  itemBuilder: (context, index) {
                    final dest = DummyData.popularDestinations[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: dest);
                      },
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              UnsplashImage(
                                query: dest['name']!,
                                fallbackUrl: dest['image'],
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      dest['name']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          dest['rating'].toString(),
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingScreen()));
                      },
                      icon: const Icon(Icons.flight_takeoff),
                      label: const Text('Book a Trip'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Messages'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trips & Tours', style: Theme.of(context).textTheme.headlineMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TripsScreen()));
                    },
                    child: const Text('View All', style: TextStyle(color: AppTheme.accentTeal)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: DummyData.popularDestinations.length,
                  itemBuilder: (context, index) {
                    final dest = DummyData.popularDestinations[index];
                    return DestinationCard(
                      destination: dest,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: dest);
                      },
                      height: 200,
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Destinations', style: Theme.of(context).textTheme.headlineMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TripsScreen()));
                    },
                    child: const Text('See All', style: TextStyle(color: AppTheme.accentTeal)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: DummyData.popularDestinations.length,
                  itemBuilder: (context, index) {
                    final dest = DummyData.popularDestinations[index];
                    return DestinationCard(
                      destination: dest,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: dest);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text('Featured Collections', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: DummyData.featuredPlaces.length,
                  itemBuilder: (context, index) {
                    final place = DummyData.featuredPlaces[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: place);
                      },
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              UnsplashImage(
                                query: place['name']!,
                                fallbackUrl: place['image'],
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                                child: Center(
                                  child: Text(
                                    place['name']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
