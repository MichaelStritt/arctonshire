import 'package:flutter/material.dart';
import 'package:arctonshire/pages/avatar_selection.dart';
import 'package:arctonshire/pages/user_profile.dart';
import 'package:arctonshire/pages/user_lobby.dart';

class NavigationProvider extends ChangeNotifier {
  late BuildContext context;
  String? _userId;
  String? _username;
  int? _avatarId;
  int? _experience;

  String? get userId => _userId;
  String? get username => _username;
  int? get avatarId => _avatarId;
  int? get experience => _experience;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setAvatarId(int avatarId) {
      _avatarId = avatarId;
      notifyListeners();
  }

  void setExperience(int experience) {
      _experience = experience;
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
        builder: (context) => UserLobbyPage(),
      ),
    );
  }

  void goBackToHomePage(BuildContext context) {
    // Use the passed context for navigation
    Navigator.of(context).pop();
  }
  
}
