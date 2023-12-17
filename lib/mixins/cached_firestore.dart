import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChachedFirestore {
  Future<Query?> getDocument(
    String path,
    Query query, {
    Duration expiryTimeInterval = const Duration(days: 1),
  }) async {
    // Get the shared preferences instance
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((pref) {
      // Check if the document is expired
      int? expiryTime = pref.getInt(path);

      if (expiryTime == null ||
          expiryTime < DateTime.now().millisecondsSinceEpoch) {
        // .then((value) {
        //   return value;
        // });
        // Set Expiry date for the document in the shared preferences
        pref.setInt(path,
            DateTime.now().add(expiryTimeInterval).millisecondsSinceEpoch);
        return query.get(const GetOptions(source: Source.server));
      } else {
        return query.get(const GetOptions(source: Source.cache));
      }
    });
    return null;
  }
}
