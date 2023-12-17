import 'package:flutter/foundation.dart';
import 'package:student/gobal/constants.dart';
import 'package:student/model/user.dart';

class UserProvider extends ChangeNotifier {
  User student = User.empty();

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
}
