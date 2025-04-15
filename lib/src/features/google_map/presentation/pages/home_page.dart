import 'package:flutter/material.dart';
import 'package:test_application/src/features/google_map/presentation/pages/map_page.dart';
import 'package:test_application/src/features/google_map/presentation/pages/saved_rides_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride booking app'), centerTitle: true),
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const MapPage()));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('Book a ride'),
                  Spacer(),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SavedRidesPage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('Booked rides'),
                  Spacer(),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Made by Artem Ruppel. A Senior Flutter developer',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
