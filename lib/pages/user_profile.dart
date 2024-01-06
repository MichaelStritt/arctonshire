import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:arctonshire/backgrounds/background_with_avatar.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<NavigationProvider>(context, listen: false).userId;

    return Scaffold(
      body: Stack(
        children: [
          // Use the BackgroundWithAvatar widget here
          BackgroundWithAvatar(userId!),

          // Centered content on top of the background
          Center(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: FirestoreService.getUserData(userId),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No user data available');
                }

                var userData = snapshot.data!;
                String username = userData['username'] ?? 'Username';
                int avatarId = userData['avatarId'] ?? 0;
                int experience = userData['experience'] ?? 0;
                //String packages = userData['packages'] ?? List.filled(100, '0').join(',');

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Username: $username'),
                    Text('Avatar ID: $avatarId'),
                    Text('Experience: $experience'),
                    // Text('Packages: $packages'),
                    // Add the "Change Avatar" button
                    ElevatedButton(
                      onPressed: () {
                        var navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
                        navigationProvider.openAvatarSelection(context);
                      },
                      child: const Text('Change Avatar'),
                    ),
                    // Add more widgets as needed to display user data
                  ],
                );
              },
            ),
          ),

          // Add a row for Increase and Decrease buttons
          Positioned(
            bottom: 16, // Adjust the position as needed
            left: 16, // Adjust the position as needed
            right: 16, // Adjust the position as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDecreaseButton(userId), // Use the null-aware operator to assert non-null
                const SizedBox(width: 20), // Add some spacing between the buttons
                _buildIncreaseButton(userId), // Use the null-aware operator to assert non-null
              ],
            ),
          ),

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

  Widget _buildIncreaseButton(String userId) {
    return ElevatedButton(
      onPressed: () async {
        // Update the Firestore data
        await FirestoreService.increaseExperience(userId, 1);
      },
      child: const Text("+EXP"),
    );
  }

  Widget _buildDecreaseButton(String userId) {
    return ElevatedButton(
      onPressed: () async {
        // Update the Firestore data
        await FirestoreService.decreaseExperience(userId, 1);
      },
      child: const Text("-EXP"),
    );
  }
}
