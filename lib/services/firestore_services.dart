import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<void> saveUserData(String userId, String username, int avatarId, int experience, String packages, String friends, bool visibility) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.set({
      'username': username,
      'avatarId': avatarId,
      'experience': experience,
      'packages': packages,
      'friends': friends,
      'visibility': visibility,
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


  static Future<bool> usernameExists(String username) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error checking username existence: $error');
      return false;
    }
  }


  // Name lists
  static List<String> listFirstNames = ["Bear", "Wolf", "Deer", "Badger", "Eagle", "Owl", "Lion", "Tiger", "Jaguar", "Leopard", "Lynx", "Cheetah", "Fox", "Raccoon", "Squirrel", "Otter", "Beaver", "Hawk", "Falcon", "Vulture", "Sparrow", "Robin", "Pigeon", "Swan", "Heron", "Cormorant", "Pelican", "Albatross", "Osprey", "Condor", "Puma", "Ocelot", "Bobcat", "Lynx", "Cougar", "Caracal", "Civet", "Hyena", "Jackal", "Fennec", "Raccoon", "Skunk", "Coyote", "Red fox", "Gray wolf", "Arctic fox", "Swift deer", "Fawn", "Moose", "Elk", "Caribou", "Bison", "Buffalo", "Antelope", "Gazelle", "Zebra", "Giraffe", "Elephant", "Rhinoceros", "Hippopotamus", "Warthog", "Wildebeest", "Lioness", "Tigress", "Panther", "Leopard", "Lynx", "Cheetah", "Fox", "Squirrel", "Otter", "Beaver", "Hawk", "Falcon", "Vulture", "Sparrow", "Robin", "Pigeon", "Swan", "Heron", "Cormorant", "Pelican", "Albatross", "Osprey", "Condor", "Puma", "Ocelot", "Bobcat", "Lynx", "Cougar", "Caracal", "Civet", "Hyena", "Jackal", "Fennec", "Raccoon", "Skunk", "Coyote"];
  static List<String> listLastNames = ["Moon", "Creek", "Sun", "Castle", "Day", "Night", "Dawn", "Citadel", "Ocean", "Sky", "Star", "Forest", "Mist", "Temple", "Twilight", "Firefly", "Whisper", "Oracle", "Sorcerer", "Wizard", "Enchantment", "Serenity", "Dreamscape", "Mirage", "Crystal", "Shadow", "Phoenix", "Elara", "Faelan", "Aelin", "Lyndor", "Nymph", "Elysium", "Zephyr", "Labyrinth", "Mystic", "Ethereal", "Illusion", "Celestial", "Alchemy", "Aurora", "Fae", "Sylph", "Wisp", "Glimmer", "Thorn", "Silhouette", "Frost", "Siren", "Noble", "Vortex", "Tempest", "Quasar", "Luna", "Selene", "Nyx", "Nocturne", "Vellichor", "Arcanum", "Solstice", "Crescent", "Sable", "Banshee", "Obelisk", "Phosphor", "Seraph", "Obsidian", "Moonshadow", "Seer", "Pentacle", "Rune", "Mystique", "Enigma", "Shapeshifter", "Verdant", "Stardust", "Sable", "Dragon", "Wyvern", "Unicorn", "Griffin", "Phoenix", "Sorcery", "Whisperwind", "Spellbound", "Ethereal", "Faerie", "Amethyst", "Elusion", "Gossamer", "Nebula", "Pandora", "Elysian", "Spirit", "Vortex", "Oracle", "Sylvan", "Midnight", "Enchantment"];


  // Random unique name
  static String generateUsername() {
    final random = Random();
    String firstName = listFirstNames[random.nextInt(listFirstNames.length)];
    String lastName = listLastNames[random.nextInt(listLastNames.length)];
    int index = random.nextInt(1000); // Generate a random index

    return '$firstName $lastName $index';
  }


  // Find unique name
  static Future<String> findUniqueUsername() async {
    int index = 1;
    while (true) {
      String potentialUsername = generateUsername();
      print('Trying username: $potentialUsername'); // Debug print

      try {
        bool exists = await FirestoreService.usernameExists(potentialUsername);
        if (!exists) {
          print('Found unique username: $potentialUsername'); // Debug print
          return potentialUsername;
        }
      } catch (e) {
        print('Error checking if username exists: $e');
        // If there's an error (like the database doesn't exist), you might want to handle it specifically here.
        // For example, you could break the loop and return a default username or handle the error differently.
      }

      index++;
      if (index > 1000) { // Just as a safety measure to avoid an infinite loop
        print('Warning: Reached 1000 iterations when trying to find a unique username.');
        break;
      }
    }

    // Add a default return statement here
    return 'Unique Bear Cub';
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


  static Future<int?> getExperience(String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userData = await userRef.get();

      if (userData.exists && userData.data()?['experience'] != null) {
        return userData.data()?['experience'] as int;
      }
    } catch (e) {
      print('Error retrieving experience: $e');
    }
    return null; // Return null if there's an error or if the data doesn't exist
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

