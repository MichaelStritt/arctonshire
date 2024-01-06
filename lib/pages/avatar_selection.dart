import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:arctonshire/classes/app_user.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/provider/navigation_provider.dart';

class AvatarSelectionPage extends StatefulWidget {
  const AvatarSelectionPage({super.key});

  @override
  AvatarSelectionPageState createState() => AvatarSelectionPageState();
}

class AvatarSelectionPageState extends State<AvatarSelectionPage> {
  late Future<int?> _selectedAvatarIdFuture;

  @override
  void initState() {
    super.initState();
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    AppUser? currentUser = navigationProvider.currentUser;

    if (currentUser != null) {
      _selectedAvatarIdFuture = FirestoreService.getAvatarId(currentUser.userId);
    } else {
      print("Error: currentUser is null");
    }
  }

  Future<void> _updateAvatarId(int newAvatarId) async {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    AppUser? currentUser = navigationProvider.currentUser;
    
    if (currentUser != null) {
      await FirestoreService.updateAvatarId(currentUser.userId, newAvatarId);

      // Update the avatar ID in the currentUser object and update NavigationProvider
      AppUser updatedUser = currentUser.copyWith(avatarId: newAvatarId);
      navigationProvider.setCurrentUser(updatedUser);

      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      print("Error: currentUser is null");
    }
  }

  Future<bool> _checkAvatarExists(String avatarPath) async {
    try {
      await rootBundle.load(avatarPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: FutureBuilder<int?>(
        future: _selectedAvatarIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Retrieve the current avatar ID. If it's null, default to -1.
          int currentAvatarId = snapshot.data ?? -1;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: 120,
            itemBuilder: (context, index) {
              bool isSelected = index == currentAvatarId;
              String avatarPath = 'assets/avatars/avatar_$index.webp';

              return FutureBuilder<bool>(
                future: _checkAvatarExists(avatarPath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
                    return _buildAvatarTile(avatarPath, isSelected, index);
                  } else {
                    return _buildAvatarTile('assets/avatars/avatar_X.webp', isSelected, index);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAvatarTile(String imagePath, bool isSelected, int index) {
    return GestureDetector(
      onTap: () async {
        await _updateAvatarId(index);
        print('Selected avatar: $index');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: isSelected ? 2.0 : 0.0,
            ),
            color: Colors.grey[300],
          ),
          child: Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
