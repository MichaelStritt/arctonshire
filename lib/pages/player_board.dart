import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/classes/app_user.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:arctonshire/backgrounds/background_player_board.dart';

class PlayerBoard extends StatefulWidget {
  @override
  _PlayerBoardState createState() => _PlayerBoardState();
}

class _PlayerBoardState extends State<PlayerBoard> {
  bool onlyFriends = false;
  List<AppUser> users = []; // Use AppUser class
  List<String> friendsList = [];

  @override
  void initState() {
    super.initState();
    initUsersAndFriendsList();
  }

  void initUsersAndFriendsList() async {
    List<AppUser> allUsers = await FirestoreService.getAllVisibleUsers();
    if (!mounted) return;

    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    AppUser? currentUser = navigationProvider.currentUser;
    if (currentUser == null) return;

    List<String> friends = await FirestoreService.getFriendsList(currentUser.userId);
    if (!mounted) return;

    setState(() {
      users = allUsers;
      friendsList = friends;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the NavigationProvider instance from the context
    final NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundPlayerBoard(
            navigationProvider.currentUser?.userId ?? '', // Use the currentUser's userId
            onAvatarTap: () => navigationProvider.openUserProfile(context),
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
}

