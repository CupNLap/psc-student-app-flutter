import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/pages/home_screen.dart';
import 'package:student/pages/sign_up.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // TODO - make sure the phone number is linked
        // || snapshot.data?.phoneNumber != null
        if (!snapshot.hasData) {
          return const SignUpPage();
        }
        // TODO - gather email details as well
        // else if(snapshot.data?.emailVerified == false) {
        //   return const GoogleSignIn();
        // }

        return const MyHomePage(title: 'Alchemist Bathery');
      },
    );
  }
}
