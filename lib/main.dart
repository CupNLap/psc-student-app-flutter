import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'pages/auth_gate.dart';
import 'provider/batch_provider.dart';
import 'provider/exam_provider.dart';
import 'provider/user_provider.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Asynchronous errors
  // Asynchronous errors are not caught by the Flutter framework:
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // Refer the following link for more about error recording
  // https://firebase.google.com/docs/crashlytics/customize-crash-reports?hl=en&authuser=0&_gl=1*1ir80e7*_ga*NTY2MTI3NzcyLjE3MDE0ODczMDI.*_ga_CW55HF8NVT*MTcwODMzNTMzNi4xNzkuMS4xNzA4MzM2MTA2LjU5LjAuMA..&platform=flutter

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BatchProvider()),
        ChangeNotifierProvider(create: (_) => ExamProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthGate(
      child: MaterialApp.router(
          title: 'Alchemist Bathery',
          theme: ThemeData(
            fontFamily: 'Inter',
            useMaterial3: false,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
            ),
          ),
          routerConfig: AppRoutes.goRoutes),
    );
  }
}
