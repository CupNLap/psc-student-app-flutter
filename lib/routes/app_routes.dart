import 'package:go_router/go_router.dart';
import 'package:version_gate/version_gate.dart';

import '../pages/home_screen.dart';
import '../pages/profile_screen.dart';

class AppRoutes {
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String profileRoute = '/profile';

  // static String initialRoute =
  //     FirebaseAuth.instance.currentUser != null ? homeRoute : loginRoute;

  // GoRouter configuration
  static GoRouter goRoutes = GoRouter(
    initialLocation: homeRoute,
    routes: [
      GoRoute(
        path: homeRoute,
        builder: (context, state) => FireStoreVersionGate(
            docPath: 'AppDetails/version',
            expiredField: "studentExpired",
            latestField: "studentLatest",
            version: 5,
            updateUrl: Uri.parse(
                "https://play.google.com/store/apps/details?id=com.alchemist.student"),
            child: const MyHomePage(title: "Alchemist Bathery")),
      ),
      // GoRoute(
      //   path: loginRoute,
      //   builder: (context, state) =>
      //       const AuthGate(),
      // ),
      GoRoute(
        path: profileRoute,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
