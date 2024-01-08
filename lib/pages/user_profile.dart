import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/classes/app_user.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:arctonshire/backgrounds/background_user_profile.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    AppUser? currentUser = navigationProvider.currentUser;

    // Ensure currentUser is not null
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('User is not available')),
      );
    }

    // Get the userId
    String userId = currentUser.userId;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundUserProfile(
            currentUser.userId, // Use currentUser's userId
            onAvatarTap: () => navigationProvider.openAvatarSelection(context),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Username: ${currentUser.username}'),
                Text('Avatar ID: ${currentUser.avatarId}'),
                Text('Experience: ${currentUser.experience}'),
                // Remove the Change Avatar button here
                ElevatedButton(
                  onPressed: () => _changeUsername(context, navigationProvider),
                  child: const Text('Change Username'),
                ),
                _buildDecreaseButton(userId, navigationProvider),
                const SizedBox(width: 20),
                _buildIncreaseButton(userId, navigationProvider),
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
    // Capture ScaffoldMessengerState before async gap
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    AppUser? currentUser = navigationProvider.currentUser;
    if (currentUser == null) {
      print("Error: Current user is null");
      return;
    }

    String? newUsername = await _showEditUsernameDialog(context, currentUser.username);

    if (newUsername != null && newUsername.isNotEmpty) {
      // Check if username already exists
      bool exists = await FirestoreService.usernameExists(newUsername);
      if (exists) {
        // Use the captured ScaffoldMessengerState to show SnackBar
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text("Username '$newUsername' is already taken."),
        ));
      } else {
        // Update Firestore
        await FirestoreService.updateUsername(currentUser.userId, newUsername);

        // Create a new AppUser instance with updated username
        AppUser updatedUser = currentUser.copyWith(username: newUsername);
        navigationProvider.setCurrentUser(updatedUser);
      }
    }
  }

  Future<String?> _showEditUsernameDialog(BuildContext context, String? currentUsername) async {
    TextEditingController usernameController = TextEditingController(text: currentUsername);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: usernameController,
            decoration: const InputDecoration(hintText: 'Enter new username'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Random'),
              onPressed: () async {
                String randomUsername = await FirestoreService.findUniqueUsername();
                usernameController.text = randomUsername; // Update the controller directly
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(usernameController.text); // Use the controller's text directly
              },
            ),
          ],
        );
      },
    );
  }



  Widget _buildIncreaseButton(String userId, NavigationProvider navigationProvider) {
    return ElevatedButton(
      onPressed: () async {
        AppUser? currentUser = navigationProvider.currentUser;
        if (currentUser != null) {
          await FirestoreService.increaseExperience(currentUser.userId, 1);
          int? newExperience = await FirestoreService.getExperience(currentUser.userId);
          if (newExperience != null) {
            AppUser updatedUser = currentUser.copyWith(experience: newExperience);
            navigationProvider.setCurrentUser(updatedUser);
          }
        }
      },
      child: const Text("+EXP"),
    );
  }


  Widget _buildDecreaseButton(String userId, NavigationProvider navigationProvider) {
    return ElevatedButton(
      onPressed: () async {
        AppUser? currentUser = navigationProvider.currentUser;
        if (currentUser != null) {
          await FirestoreService.decreaseExperience(currentUser.userId, 1);
          int? newExperience = await FirestoreService.getExperience(currentUser.userId);
          if (newExperience != null) {
            AppUser updatedUser = currentUser.copyWith(experience: newExperience);
            navigationProvider.setCurrentUser(updatedUser);
          }
        }
      },
      child: const Text("+EXP"),
    );
  }


}
