import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student/gobal/constants.dart';
import 'package:student/model/user.dart';

/// A class that provides user data and functionality for the application.
///
/// This class extends the [ChangeNotifier] class, allowing it to notify listeners
/// when the user data is updated.
///
/// The [UserProvider] class contains a [User] object named 'student' which represents
/// the current user of the application. The initial value of 'student' is an empty
/// [User] object.
///
class UserProvider extends ChangeNotifier {
  User student = User.empty();

  /// The [fetchUserDetails] method is used to fetch the user details from the database.
  /// It returns a [Future] that resolves to a [User] object. The method uses the
  /// 'currentUserRef' reference to retrieve the user data from the database and
  /// converts it to a [User] object using the provided converters. Once the user data
  /// is retrieved and assigned to the 'student' object, the [notifyListeners] method
  /// is called to notify any listeners that the user data has been updated.
  ///
  /// Example usage:
  /// ```dart
  /// UserProvider userProvider = UserProvider();
  /// User user = await userProvider.fetchUserDetails();
  /// print(user.name);
  /// ```
  Future<User> fetchUserDetails() {
    return currentUserRef
        .withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromFirestore(snapshot),
            toFirestore: (user, _) => user.toFirestore())
        .get()
        .then((value) {
      student = value.data()!;

      notifyListeners();
      return student;
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(forceCodeForRefreshToken: true).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Link the google account with the current user
    await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);

    // Once the user successfull linked, sign in the user with the google credential
    await FirebaseAuth.instance.signOut();

    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}
