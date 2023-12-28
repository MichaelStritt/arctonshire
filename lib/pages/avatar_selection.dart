import 'package:flutter/material.dart';
import 'package:arctonshire/services/firestore_services.dart';

class AvatarSelectionPage extends StatefulWidget {
  final String userId;

  AvatarSelectionPage({required this.userId});

  @override
  _AvatarSelectionPageState createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  late Future<int?> _selectedAvatarIdFuture;
  int? _currentAvatarId;

  @override
  void initState() {
    super.initState();
    _selectedAvatarIdFuture = FirestoreService.getAvatarId(widget.userId);
  }

  Future<void> _updateAvatarId(int newAvatarId) async {
    await FirestoreService.updateAvatarId(widget.userId, newAvatarId);
    setState(() {
      _currentAvatarId = newAvatarId;
    });
    // Navigate back to the home page after selecting an avatar
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove the app bar
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 16, // Replace with your total number of avatars
        itemBuilder: (context, index) {
          bool isSelected = index == _currentAvatarId;
          return GestureDetector(
            onTap: () async {
              await _updateAvatarId(index);
              print('Selected avatar: $index');
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: isSelected ? 2.0 : 0.0,
                  ),
                  color: Colors.grey[300],
                ),
                child: Image.asset(
                  'assets/avatars/avatar_$index.webp',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




