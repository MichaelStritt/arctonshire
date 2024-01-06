import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:arctonshire/backgrounds/background_with_avatar.dart';

class UserLobbyPage extends StatelessWidget {
  const UserLobbyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using Provider to access NavigationProvider
    final navigationProvider = Provider.of<NavigationProvider>(context);

    // Accessing userId, username, avatarId, and experience from NavigationProvider
    String? userId = navigationProvider.userId;

    if (userId == null) {
      // Handle the null case, e.g., navigate back or show an error message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return const Scaffold(body: Center(child: Text('User ID not available')));
    }

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWithAvatar(
            userId, // Use the non-null userId here
            onAvatarTap: () => navigationProvider.openUserProfile(context),
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 30.0),
              onPressed: () {
                navigationProvider.goBackToHomePage(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
