import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/services/firestore_services.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    String? userId = Provider.of<NavigationProvider>(context, listen: false).userId;

    if (userId != null) {
      _userDataFuture = FirestoreService.getUserData(userId);
    } else {
      // Handle the case when userId is null.
      print("Error: userId is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content of the page
          FutureBuilder<Map<String, dynamic>?>(
            future: _userDataFuture,
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No user data available'));
              }

              var userData = snapshot.data!;
              String username = userData['username'] ?? 'Username';
              int avatarId = userData['avatarId'] ?? 0;
              int experience = userData['experience'] ?? 0;
              String packages = userData['packages'] ?? List.filled(100, '0').join(',');

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Username: $username'),
                    Text('Avatar ID: $avatarId'),
                    Text('Experience: $experience'),
                    Text('Packages: $packages'),
                    // Add more widgets as needed to display user data
                  ],
                ),
              );
            },
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top, // Respect the status bar height
            right: 0,
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

