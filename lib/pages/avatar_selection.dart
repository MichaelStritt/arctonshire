import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
    Navigator.pop(context);
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
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 120,
        itemBuilder: (context, index) {
          bool isSelected = index == _currentAvatarId;
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
