import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:student/pages/auth_gate.dart';

import '../pages/home_screen.dart';
import '../pages/profile_screen.dart';

class AppRoutes {
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String profileRoute = '/profile';

  static String initialRoute =
      FirebaseAuth.instance.currentUser != null ? homeRoute : loginRoute;

  // GoRouter configuration
  static GoRouter goRoutes = GoRouter(
    initialLocation: initialRoute,
    routes: [
    GoRoute(
      path: homeRoute,
      builder: (context, state) =>
          const MyHomePage(title: "Kerala PSC Insitute"),
    ),
    GoRoute(
      path: loginRoute,
      builder: (context, state) =>
          const AuthGate(),
    ),
    GoRoute(
      path: profileRoute,
      builder: (context, state) => const ProfileScreen(),
    ),
  ]);
}
