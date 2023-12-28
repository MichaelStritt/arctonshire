import 'package:flutter/material.dart';
import 'package:arctonshire/pages/avatar_selection.dart';

class NavigationProvider extends ChangeNotifier {
  late BuildContext context;

  void setContext(BuildContext context) {
    this.context = context;
  }

  void openAvatarSelection(BuildContext context, String userId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvatarSelectionPage(userId: userId),
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


