import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arctonshire/services/firestore_services.dart';
import 'package:arctonshire/provider/navigation_provider.dart';

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
    const double buttonWidth = 250; // Set your preferred button width here
    const double buttonHeight = 50; // Set the button height here
    const double buttonPadding = 10; // Set the vertical padding between buttons here
    const double fontSize = 20; // Set your preferred font size here

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
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
                          // Handle "New Game" button click
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Set the button background color to white
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, // Make the font bold
                            fontSize: fontSize, // Set the font size
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Adjust the corner radius here
                          ),
                        ),
                        child: const Text('New Game'),
                      ),
                    ),
                    const SizedBox(height: buttonPadding), // Add vertical padding between buttons
                    SizedBox(
                      width: buttonWidth,
                      height: buttonHeight, // Set the button height
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle "..." button click
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Set the button background color to white
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, // Make the font bold
                            fontSize: fontSize, // Set the font size
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Adjust the corner radius here
                          ),
                        ),
                        child: const Text('...'),
                      ),
                    ),
                    const SizedBox(height: buttonPadding), // Add vertical padding between buttons
                    SizedBox(
                      width: buttonWidth,
                      height: buttonHeight, // Set the button height
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle "About" button click
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Set the button background color to white
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, // Make the font bold
                            fontSize: fontSize, // Set the font size
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
          
          // Positioned avatar image at the top right corner
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                var navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
                navigationProvider.openUserProfile(context); // Navigate to UserProfilePage
              },
              child: FutureBuilder<int?>(
                future: FirestoreService.getAvatarId(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int? userAvatarId = snapshot.data;
                    return userAvatarId != null
                        ? Image.asset(
                            'assets/avatars/avatar_$userAvatarId.webp',
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
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
      // Attempt to sign in with Google
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);

        // Retrieve the current user's ID
        String userId = userCredential.user!.uid;

        if (!mounted) return;

        // Check if the user's document exists in Firestore
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (!mounted) return;

        // Set the userId for the navigation provider
        Provider.of<NavigationProvider>(context, listen: false).setUserId(userId);

        // Set the context for the navigation provider
        Provider.of<NavigationProvider>(context, listen: false).setContext(context);

        if (!docSnapshot.exists) {
          // Document doesn't exist, create it with initial data
          String username = 'Bear Cub';
          int avatarId = 0;
          int experience = 0;

          // Generate a string of 100 zeros separated by commas
          String packages = List.filled(100, '0').join(',');

          await FirestoreService.saveUserData(userId, username, avatarId, experience, packages);
          print('User data created for initial login...');
        } else {
          // Document already exists, no need to create it again
          print('User document already exists...');
        }

      }
    } catch (error) {
      print("Error during sign-in: $error");
    } finally {
      if (!mounted) return;
      setState(() {
        _showSignInButton = true; // Show the sign-in button again after sign-in attempt
      });
    }
  }



}