import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arctonshire/classes/app_user.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:arctonshire/backgrounds/background_user_lobby.dart';

class UserLobby extends StatefulWidget {
  @override
  _UserLobbyState createState() => _UserLobbyState();
}

class _UserLobbyState extends State<UserLobby> {
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

  List<AppUser> getFilteredUsers() {
    if (onlyFriends) {
      return users.where((user) => friendsList.contains(user.userId) && user.visibility).toList();
    } else {
      return users.where((user) => user.visibility).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the NavigationProvider instance from the context
    final NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false);

    List<AppUser> filteredUsers = getFilteredUsers();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundUserLobby(
            navigationProvider.currentUser?.userId ?? '', // Use the currentUser's userId
            onAvatarTap: () => navigationProvider.openUserProfile(context),
          ),

          // For testing
          ElevatedButton(
            onPressed: () {
              var navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
              navigationProvider.openPlayerBoardPage(context); // Navigate to PlayerBoardPage
            },
            child: const Text('PlayerBoard'), // Add the child widget here
          ),

          /*
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // This centers the column's children vertically
              children: <Widget>[
                CheckboxListTile(
                  title: const Text("Only Friends"),
                  value: onlyFriends,
                  onChanged: (bool? newValue) {
                    setState(() {
                      onlyFriends = newValue ?? false; // Provide false as default value
                    });
                  },
                ),
                Expanded(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Username')),
                      // Add other columns here
                    ],
                    rows: filteredUsers.map((user) => DataRow(cells: [
                          DataCell(Text(user.username)),
                          // Add other cells here
                        ])).toList(),
                  ),
                ),
              ],
            ),
          ),
          */

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

