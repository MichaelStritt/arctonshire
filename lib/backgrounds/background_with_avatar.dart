import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/services/firestore_services.dart';


class BackgroundWithAvatar extends StatelessWidget {
  final String userId;

  const BackgroundWithAvatar(this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.black, // Set the background color to black
        image: DecorationImage(
          image: AssetImage("assets/interface/homePageBackground.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Positioned avatar image at the top right corner
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                var navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
                navigationProvider.openUserProfile(context); // Navigate to UserProfilePage
              },
              child: FutureBuilder<int?>(
                future: FirestoreService.getAvatarId(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int? userAvatarId = snapshot.data;
                    return userAvatarId != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0, right: 12.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/avatars/avatar_$userAvatarId.webp',
                                  height: 140,
                                  width: 140,
                                  fit: BoxFit.cover,
                                ),
                                Image.asset(
                                  'assets/interface/avatarFrame.png',
                                  height: 160,
                                  width: 160,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}