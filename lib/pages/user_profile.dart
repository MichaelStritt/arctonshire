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
                ElevatedButton(
                  onPressed: () => _changeUsername(context, navigationProvider),
                  child: const Text('Change Username'),
                ),
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

  Future<void> _changeUsername(BuildContext context, NavigationProvider navigationProvider) async {
    String? newUsername = await _showEditUsernameDialog(context, navigationProvider.username);

    if (newUsername != null && newUsername.isNotEmpty) {
      // Update Firestore
      await FirestoreService.updateUsername(navigationProvider.userId!, newUsername);
      // Update NavigationProvider
      navigationProvider.setUsername(newUsername);
    }
  }

  Future<String?> _showEditUsernameDialog(BuildContext context, String? currentUsername) async {
    String? newUsername;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            onChanged: (value) {
              newUsername = value;
            },
            decoration: InputDecoration(hintText: currentUsername ?? 'Enter new username'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(newUsername);
              },
            ),
          ],
        );
      },
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
