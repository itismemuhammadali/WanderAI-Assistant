import 'package:flutter/material.dart';
import '../core/dummy_data.dart';
import '../core/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/destination_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Explore'),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: DummyData.popularDestinations.length * 2, // Doubling for dummy grid effect
        itemBuilder: (context, index) {
          final dest = DummyData.popularDestinations[index % DummyData.popularDestinations.length];
          return DestinationCard(
            destination: dest,
            isHorizontal: false,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.destinationDetail, arguments: dest);
            },
          );
        },
      ),
    );
  }
}
