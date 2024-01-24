import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:student/pages/auth_gate.dart';
import 'package:student/provider/batch_provider.dart';
import 'package:student/provider/exam_provider.dart';
import 'package:student/provider/user_provider.dart';
import 'package:student/routes/app_routes.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
