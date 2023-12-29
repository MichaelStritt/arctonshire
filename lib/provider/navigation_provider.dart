import 'package:flutter/material.dart';
import 'package:arctonshire/pages/avatar_selection.dart';
import 'package:arctonshire/pages/user_profile.dart';

class NavigationProvider extends ChangeNotifier {
  late BuildContext context;
  String? _userId;

  String? get userId => _userId;

  void setUserId(String userId) {
    _userId = userId;
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

  void goBackToHomePage() {
    if (context != null) {
      Navigator.pop(context);
    } else {
      print('Context is not set...');
    }
  }
}
