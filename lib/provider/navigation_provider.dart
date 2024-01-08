import 'package:flutter/material.dart';
import 'package:arctonshire/classes/app_user.dart';
import 'package:arctonshire/pages/avatar_selection.dart';
import 'package:arctonshire/pages/user_profile.dart';
import 'package:arctonshire/pages/user_lobby.dart';
import 'package:arctonshire/pages/player_board.dart';

class NavigationProvider extends ChangeNotifier {
  late BuildContext context;
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  void setCurrentUser(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void resetCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    this.context = context;
  }

  void openAvatarSelection(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvatarSelectionPage(),
      ),
    );
  }

  void openUserProfile(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(),
      ),
    );
  }

  void openUserLobbyPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserLobby(),
      ),
    );
  }

  void openPlayerBoardPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerBoard(),
      ),
    );
  }

  void goBackToHomePage(BuildContext context) {
    Navigator.of(context).pop();
  }
}
