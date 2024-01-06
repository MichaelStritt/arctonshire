import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:arctonshire/provider/navigation_provider.dart';
import 'package:arctonshire/backgrounds/background_with_avatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Firebase Authentication instance for handling authentication operations
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google Sign-In instance for handling Google sign-in functionality
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // The variable to hold the currently authenticated user
  User? _user;

  // Add a variable to control the visibility of the sign-in button
  bool _showSignInButton = true;


  @override
  void initState() {
    super.initState();
    // Listening to changes in the authentication state
    // When the authentication state changes, update the _user variable
    _auth.authStateChanges().listen((User? event) {
      setState(() {
        _user = event; // Update _user with the new authentication state
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _user != null
          ? _buildStartPage()
          : _showSignInButton // Check if the sign-in button should be visible
              ? _googleSignInButton()
              : const Center(child: CircularProgressIndicator()), // Display loading indicator instead of sign-in button
    );
  }


  Widget _googleSignInButton({
    double buttonWidth = 250, // Set the button width here
    double buttonHeight = 50, // Set the button height here
    double cornerRadius = 10, // Set the corner radius here
  }) {
    return Center(
      child: SizedBox(
        width: buttonWidth, // Set the button width
        height: buttonHeight, // Set the button height
        child: SignInButton(
          Buttons.google,
          text: "Sign in with Google",
          onPressed: () {
            if (_showSignInButton) {
              _handleGoogleSignIn();
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius), // Set the corner radius
          ),
        ),
      ),
    );
  }


  Future<void> _handleGoogleSignOut() async {
    // Sign out from Firebase
    await _auth.signOut();
    // Sign out from Google Sign-In
    await _googleSignIn.signOut();
  }


  Widget _buildLoadingWidget() {
      return const Center(
        child: CircularProgressIndicator(),
      );
  }


  Widget _buildStartPage() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_user!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget(); // Display loading indicator
        }

        // Initialize the user data
        Map<String, dynamic>? userData;

        // Check if there were some errors
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          print('No data available...');
        } else {
          // Access user data from the snapshot
          userData = snapshot.data!.data() as Map<String, dynamic>;
        }

        // Get values and define defaults if not available
        int avatarId = userData?['avatarId'] ?? 0;

        // Build the clickable avatar
        return _buildStartPageWidget(_user!.uid, avatarId);
      },
    );
  }


  Widget _buildStartPageWidget(String userId, int avatarId) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    const double buttonWidth = 250; // Set your preferred button width here
    const double buttonHeight = 50; // Set the button height here
    const double buttonPadding = 10; // Set the vertical padding between buttons here
    const double fontSize = 20; // Set your preferred font size here

    return Stack(
      children: [
        // Use the BackgroundWithAvatar widget here
        BackgroundWithAvatar(
          userId,
          onAvatarTap: () => navigationProvider.openUserProfile(context),
        ),
        // Buttons and other content
        Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center the buttons horizontally
          mainAxisSize: MainAxisSize.max,
          children: [
            // Add the three centered buttons here
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight, // Set the button height
                    child: ElevatedButton(
                      onPressed: () {
                        var navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
                        navigationProvider.openUserLobbyPage(context); // Navigate to UserLobbyPage
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900], // Set the button background color to a really dark gray
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, // Make the font bold
                          fontSize: fontSize, // Set the font size
                          color: Colors.white, // Set the font color to perfect white
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Adjust the corner radius here
                        ),
                      ),
                      child: const Text('Play'),
                    ),
                  ),
                  const SizedBox(height: buttonPadding), // Add vertical padding between buttons
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight, // Set the button height
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle "Adventure" button click
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900], // Set the button background color to a really dark gray
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, // Make the font bold
                          fontSize: fontSize, // Set the font size
                          color: Colors.white, // Set the font color to perfect white
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Adjust the corner radius here
                        ),
                      ),
                      child: const Text('Adventure'),
                    ),
                  ),
                  const SizedBox(height: buttonPadding), // Add vertical padding between buttons
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight, // Set the button height
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle "Shop" button click, in the shop we will set the packages based on if a user bought a package or not
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900], // Set the button background color to a really dark gray
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, // Make the font bold
                          fontSize: fontSize, // Set the font size
                          color: Colors.white, // Set the font color to perfect white
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Adjust the corner radius here
                        ),
                      ),
                      child: const Text('Shop'),
                    ),
                  ),
                  const SizedBox(height: buttonPadding), // Add vertical padding between buttons
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight, // Set the button height
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle "About" button click, in the about section we will display legal information and so on
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900], // Set the button background color to a really dark gray
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, // Make the font bold
                          fontSize: fontSize, // Set the font size
                          color: Colors.white, // Set the font color to perfect white
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Adjust the corner radius here
                        ),
                      ),
                      child: const Text('About'),
                    ),
                  ),
                  const SizedBox(height: buttonPadding), // Add vertical padding between buttons
                ],
              ),
            ),

            _buildSignOutButton(), // Display sign-out button
          ],
        ),
      ],
    );
  }



  Widget _buildSignOutButton() {
    const double buttonWidth = 250; // Set the button width here
    const double buttonHeight = 50; // Set the button height here

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight, // Set the button height
      child: MaterialButton(
        color: Colors.red,
        onPressed: _handleGoogleSignOut,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Adjust the corner radius here
        ),
        child: const Text(
          "Sign out",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the font bold
            fontSize: 20, // Adjust the font size here
          ),
        ),
      ),
    );
  }


  void _handleGoogleSignIn() async {
    setState(() {
      _showSignInButton = false; // Hide the sign-in button
    });

    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);
        String userId = userCredential.user!.uid;

        if (!mounted) return;

        final NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
        Map<String, dynamic>? userData = await FirestoreService.getUserData(userId);

        if (userData == null) {
          // New user, generate a unique username
          String uniqueUsername = await FirestoreService.findUniqueUsername();
          int avatarId = 0; // Default avatar ID for new users
          int experience = 0; // Default experience for new users
          String packages = List.filled(100, '0').join(',');
          String friends = '';
          bool visibility = false;

          // Save new user data
          await FirestoreService.saveUserData(userId, uniqueUsername, avatarId, experience, packages, friends, visibility);
          print('User data created for initial login...');

          // Update NavigationProvider with new user data
          navigationProvider.setUserId(userId);
          navigationProvider.setUsername(uniqueUsername);
          navigationProvider.setAvatarId(avatarId);
          navigationProvider.setExperience(experience);
          navigationProvider.setPackages(packages);
          navigationProvider.setFriends(friends);
          navigationProvider.setVisibility(visibility);
        } else {
          // Existing user
          navigationProvider.setUserId(userId);
          navigationProvider.setUsername(userData['username']);
          navigationProvider.setAvatarId(userData['avatarId'] ?? 0);
          navigationProvider.setExperience(userData['experience'] ?? 0);
          navigationProvider.setPackages(userData['packages'] ?? List.filled(100, '0').join(','));
          navigationProvider.setFriends(userData['friends'] ?? 0);
          navigationProvider.setVisibility(userData['visibility'] ?? 0);

          print('User document already exists...');
        }
      }
    } catch (error) {
      print("Error during sign-in: $error");
    } finally {
      if (!mounted) return;
      setState(() {
        _showSignInButton = true;
      });
    }
  }

}
