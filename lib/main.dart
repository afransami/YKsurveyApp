import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize
  await Firebase.initializeApp();

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Portrait mode only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const BhumiSurveyApp());
}

class BhumiSurveyApp extends StatelessWidget {
  const BhumiSurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ভূমি সার্ভে ম্যানেজার',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primary),
                    SizedBox(height: 16),
                    Text('লোড হচ্ছে...'),
                  ],
                ),
              ),
            );
          }
          if (snap.hasData && snap.data != null) {
            return const MainScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
