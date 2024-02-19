import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:student/utils/date.dart';

class CrashKey {
  static const page = 'page';
}

void logPageName(String page) {
  crashLog(page);
}

void crashLog(String page, [String? message]) {
  FirebaseCrashlytics.instance
      .log('${formattedDate(DateTime.now())} : ${page} : $message');
}
