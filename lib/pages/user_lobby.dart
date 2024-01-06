import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:arctonshire/backgrounds/background_with_avatar.dart';

class UserLobbyPage extends StatelessWidget {
  const UserLobbyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? userId = Provider.of<NavigationProvider>(context, listen: false).userId;

    return Scaffold(
      body: Stack(
        children: [
          // Use the BackgroundWithAvatar widget here
          BackgroundWithAvatar(userId!),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top, // Respect the status bar height
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 30.0),
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false).goBackToHomePage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
