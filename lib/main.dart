import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();

  final bool onboardingCompleted =
      prefs.getBool('onboarding_completed') ?? false;

  runApp(
    BikerApp(
      onboardingCompleted: onboardingCompleted,
    ),
  );
}

class BikerApp extends StatelessWidget {
  const BikerApp({
    super.key,
    required this.onboardingCompleted,
  });

  final bool onboardingCompleted;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIKER',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111111),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.dark,
        ),

        useMaterial3: true,
      ),

      home: onboardingCompleted
          ? const HomeScreen()
          : const WelcomeScreen(),
    );
  }
}