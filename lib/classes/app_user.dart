class AppUser {
  final String userId;
  final String username;
  final int avatarId;
  final int experience;
  final String packages;
  final String friends;
  final bool visibility;

  AppUser({
    required this.userId,
    required this.username,
    required this.avatarId,
    required this.experience,
    required this.packages,
    required this.friends,
    required this.visibility,
  });

  AppUser copyWith({
    String? userId,
    String? username,
    int? avatarId,
    int? experience,
    String? packages,
    String? friends,
    bool? visibility,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarId: avatarId ?? this.avatarId,
      experience: experience ?? this.experience,
      packages: packages ?? this.packages,
      friends: friends ?? this.friends,
      visibility: visibility ?? this.visibility,
    );
  }

  factory AppUser.fromFirestore(Map<String, dynamic> firestore) {
    return AppUser(
      userId: firestore['userId'],
      username: firestore['username'],
      avatarId: firestore['avatarId'],
      experience: firestore['experience'],
      packages: firestore['packages'],
      friends: firestore['friends'],
      visibility: firestore['visibility'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'username': username,
      'avatarId': avatarId,
      'experience': experience,
      'packages': packages,
      'friends': friends,
      'visibility': visibility,
    };
  }
}