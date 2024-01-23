import 'package:firebase_auth/firebase_auth.dart' hide PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:student/pages/home_screen.dart';
import 'package:version_gate/version_gate.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // return const SignUpPage();
          return SignInScreen(providers: [
            PhoneAuthProvider(),
            // GoogleProvider(clientId: "AIzaSyB7LvpHUOr8utXvKeF0fYZqCmGTl37tqag")
            GoogleProvider(clientId: "AIzaSyB7LvpHUOr8utXvKeF0fYZqCmGTl37tqag")
          ]);
        }

        return FireStoreVersionGate(
          docPath: 'AppDetails/version',
          expiredField: "studentExpired",
          latestField: "studentLatest",
          version: 0.0,
          updateUrl: Uri.parse(
              "https://play.google.com/store/apps/details?id=com.alchemistbathery.student"),
          child: const MyHomePage(title: 'Alchemist Bathery'),
        );
      },
    );
  }
}
