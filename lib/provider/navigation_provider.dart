import 'package:flutter/material.dart';
import 'package:arctonshire/pages/avatar_selection.dart';

class NavigationProvider extends ChangeNotifier {
  late BuildContext context;
  String? _userId; // Add a private userId variable

  // Getter for userId
  String? get userId => _userId;

  // Setter for userId
  void setUserId(String userId) {
    _userId = userId;
    notifyListeners(); // Notify listeners about the change
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

  void goBackToHomePage() {
    if (context != null) {
      Navigator.pop(context);
    } else {
      print('Context is not set...');
    }
  }
}
