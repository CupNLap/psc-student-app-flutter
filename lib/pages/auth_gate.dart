import 'package:firebase_auth/firebase_auth.dart' hide PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import '../gobal/crash_consts.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    logPageName('auth_gate.dart');

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
            home: SignInScreen(
              providers: [
                PhoneAuthProvider(),
                GoogleProvider(
                    clientId: "AIzaSyB7LvpHUOr8utXvKeF0fYZqCmGTl37tqag"),
              ],
            ),
          );
        }

        // TODO - BUG - When the user logs out and then logs back in, it shows the
        //  details of the previous user.
        //  Rootcause - the state is not updated
        return child;
      },
    );
  }
}
