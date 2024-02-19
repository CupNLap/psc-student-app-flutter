import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashKey {
  static const page = 'page';
}

void logPageName(String page) {
  crashLog(page);
}

void crashLog(String page, [String? message]) {
  FirebaseCrashlytics.instance
      .log('${DateTime.now().millisecondsSinceEpoch} : ${page} : $message');
}
