import 'package:arctonshire/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:arctonshire/provider/navigation_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: const Arctonshire(), // Replace YourApp() with Arctonshire()
    ),
  );
}


class Arctonshire extends StatelessWidget {
  const Arctonshire({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arctonshire',
      theme: ThemeData.dark().copyWith(
        // Adjust primary color, text themes, and other properties
        primaryColor: Colors.deepPurple,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          // Define other text styles...
        ),
        // Other theme settings...
      ),
      home: HomePage(),
    );
  }
}

