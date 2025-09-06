import 'package:flutter/material.dart';

// Step 2: App Screen
import 'package:learn_flutter_67_2_2/first_screen.dart';

// Step 5: Firebase configuration
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Step 5: Firebase configuration
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 2: App Screen
    return MaterialApp(home: FirstScreen(), debugShowCheckedModeBanner: false);
  }
}
