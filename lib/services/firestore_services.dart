import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<void> saveUserData(String userId, String username, int avatarId, int experience, String packages) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.set({
      'username': username,
      'avatarId': avatarId,
      'experience': experience,
      'packages': packages,
    });
  }


  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userData = await userRef.get();

      if (userData.exists) {
        return userData.data();
      } else {
        // Handle the case where user data doesn't exist
        return null;
      }
    } catch (e) {
      // Handle any potential errors or exceptions
      print('Error retrieving user data: $e');
      return null;
    }
  }
  

  static Future<void> updateUsername(String userId, String newUsername) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      await userRef.update({
        'username': newUsername,
      });
    } catch (error) {
      print('Error updating username: $error');
      // Handle error accordingly if needed
    }
  }


  static Future<void> updateAvatarId(String userId, int newAvatarId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      await userRef.update({
        'avatarId': newAvatarId,
      });
    } catch (error) {
      print('Error updating avatar ID: $error');
      // Handle error accordingly if needed
    }
  }


  static Future<int?> getAvatarId(String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userData = await userRef.get();

      if (userData.exists) {
        return userData.data()?['avatarId'];
      } else {
        // Handle the case where user data doesn't exist
        return null;
      }
    } catch (e) {
      // Handle any potential errors or exceptions
      print('Error retrieving avatarId: $e');
      return null;
    }
  }


  static Future<void> updateExperience(String userId, int newExperience) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      await userRef.update({
        'experience': newExperience,
      });
    } catch (error) {
      print('Error updating experience: $error');
      // Handle error accordingly if needed
    }
  }


  static Future<void> increaseExperience(String userId, int increaseBy) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Get current experience value
      DocumentSnapshot snapshot = await userRef.get();
      int currentExperience = snapshot['experience'] ?? 0;

      // Increase experience by the given value
      int newExperience = currentExperience + increaseBy;

      // Update the 'experience' field in Firestore
      await userRef.update({
        'experience': newExperience,
      });
    } catch (error) {
      print('Error increasing experience: $error');
      // Handle error accordingly if needed
    }
  }

  
  static Future<void> decreaseExperience(String userId, int decreaseBy) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Get current experience value
      DocumentSnapshot snapshot = await userRef.get();
      int currentExperience = snapshot['experience'] ?? 0;

      // Decrease experience by the given value
      int newExperience = currentExperience - decreaseBy;
      if (newExperience < 0) {
        newExperience = 0; // Ensure experience doesn't go below 0
      }

      // Update the 'experience' field in Firestore
      await userRef.update({
        'experience': newExperience,
      });
    } catch (error) {
      print('Error decreasing experience: $error');
      // Handle error accordingly if needed
    }
  }


  static Future<bool> checkPackageStatusAtIndex(String userId, int index) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userData = await userRef.get();

      if (userData.exists) {
        // Get the 'packages' field and split it by ","
        String packagesString = userData.data()?['packages'] ?? '';
        List<String> packageList = packagesString.split(',');

        // Convert each string in the list to an integer
        List<int> packageStatuses = packageList.map(int.parse).toList();

        // Check if the index is within the range and if the value is 1
        if (index >= 0 && index < packageStatuses.length) {
          int valueAtIndex = packageStatuses[index];
          return valueAtIndex == 1;
        } 
      } 
    } catch (error) {
      print('Error in checkPackageStatusAtIndex: $error');
    }
    // Return false if user data doesn't exist, index is out of range, or any error occurs
    return false;
  }


}

