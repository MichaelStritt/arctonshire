import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:arctonshire/backgrounds/background_with_avatar.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using Provider to access NavigationProvider
    final navigationProvider = Provider.of<NavigationProvider>(context);

    // Accessing userId, username, avatarId, and experience from NavigationProvider
    String? userId = navigationProvider.userId;
    String? username = navigationProvider.username;
    int? avatarId = navigationProvider.avatarId;
    int? experience = navigationProvider.experience;

    // Ensure userId is not null
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('User ID is not available')),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWithAvatar(userId),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Username: $username'),
                Text('Avatar ID: $avatarId'),
                Text('Experience: $experience'),
                ElevatedButton(
                  onPressed: () {
                    navigationProvider.openAvatarSelection(context);
                  },
                  child: const Text('Change Avatar'),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDecreaseButton(userId),
                const SizedBox(width: 20),
                _buildIncreaseButton(userId),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 30.0),
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false)
                    .goBackToHomePage(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncreaseButton(String userId) {
    return ElevatedButton(
      onPressed: () async {
        await FirestoreService.increaseExperience(userId, 1);
      },
      child: const Text("+EXP"),
    );
  }

  Widget _buildDecreaseButton(String userId) {
    return ElevatedButton(
      onPressed: () async {
        await FirestoreService.decreaseExperience(userId, 1);
      },
      child: const Text("-EXP"),
    );
  }
}
