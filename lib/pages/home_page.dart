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
      // Remove the appBar parameter
      body: _user != null
          ? _userInfo()
          : _showSignInButton // Check if the sign-in button should be visible
              ? _googleSignInButton()
              : const Center(child: CircularProgressIndicator()), // Display loading indicator instead of sign-in button
    );
  }


  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign in with Google",
          onPressed: () {
            if (_showSignInButton) {
              _handleGoogleSignIn();
            }
          },
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

  Widget _userInfo() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_user!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget(); // Display loading indicator
        }

        // Initialize connection message
        String connectionMessage = '';

        // Initialize the user data
        Map<String, dynamic>? userData;

        // Check if there were some errors
        if (snapshot.hasError) {
          connectionMessage = 'Error: ${snapshot.error}';
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          connectionMessage = 'No data available';
        } else {
          // Access user data from the snapshot
          userData = snapshot.data!.data() as Map<String, dynamic>;
        }

        // Get values and define defaults if not available
        String username = userData?['username'] ?? 'Username';
        int avatarId = userData?['avatarId'] ?? 0;
        int experience = userData?['experience'] ?? 0;

        // Build the actual widget
        return _buildProfileInfoWidget(connectionMessage, _user!.uid, username, avatarId, experience);
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }


  Widget _buildProfileInfoWidget(String? connectionMessage, String userId, String username, int avatarId, int experience) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Display the user's avatar based on the avatar ID
          FutureBuilder<int?>(
            future: FirestoreService.getAvatarId(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Show error if data retrieval fails
              } else {
                int? userAvatarId = snapshot.data;
                return userAvatarId != null
                    ? Image.asset(
                        'assets/avatars/avatar_$userAvatarId.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(); // Show an empty SizedBox if no avatar ID is found
              }
            },
          ),
          // Display the user's email address if _user is not null
          Text(_user?.email ?? ""),
          // Display the user's display name (if available) if _user is not null
          Text(_user?.displayName ?? ""),
          // Display information if something went wrong
          // if (connectionMessage != null) Text('Database connection: $connectionMessage'),
          // Display username, avatarId, and experience from Firestore
          Text('Username: $username'),
          Text('Avatar ID: $avatarId'),
          Text('Experience: $experience'),

          // Add a button to change avatar
          ElevatedButton(
            onPressed: () {
              var navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
              navigationProvider.openAvatarSelection(context, userId);
            },
            child: const Text('Change Avatar'),
          ),

          // Add buttons to increase and decrease experience
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDecreaseButton(userId),
              const SizedBox(width: 20), // Add some spacing between the buttons
              _buildIncreaseButton(userId),
            ],
          ),

          _buildSignOutButton(), // Display sign-out button
        ],
      ),
    );
  }


  Widget _buildIncreaseButton(String userId) {
    return ElevatedButton(
      onPressed: () async {
        // Update the Firestore data
        await FirestoreService.increaseExperience(userId, 1);
      },
      child: const Text("+EXP"),
    );
  }


  Widget _buildDecreaseButton(String userId) {
    return ElevatedButton(
      onPressed: () async {
        // Update the Firestore data
        await FirestoreService.decreaseExperience(userId, 1);
      },
      child: const Text("-EXP"),
    );
  }


  Widget _buildSignOutButton() {
    return MaterialButton(
      color: Colors.red,
      onPressed: _handleGoogleSignOut,
      child: const Text("Sign out"),
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
        GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);
      
        // Retrieve the current user's ID
        String userId = userCredential.user!.uid;

        // Check if the user's document exists in Firestore
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (!docSnapshot.exists) {
          // Document doesn't exist, create it with initial data
          String username = 'Bear Cub';
          int avatarId = 0;
          int experience = 0;

          await FirestoreService.saveUserData(userId, username, avatarId, experience);
          print('User data created for initial login...');
          
        } else {
          // Document already exists, no need to create it again
          print('User document already exists...');
          
        }
      }
    } catch (error) {
      print("Error during sign-in: $error");
    } finally {
      setState(() {
        _showSignInButton = true; // Show the sign-in button again after sign-in attempt
      });
    }
  }

}