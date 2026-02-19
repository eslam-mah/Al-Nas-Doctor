import 'package:alnas_doctor/features/authentication/auth_router.dart';
import 'package:alnas_doctor/features/profile/profile_router.dart';
import 'package:alnas_doctor/features/splash/splash_screen.dart';
import 'package:alnas_doctor/features/home/home_router.dart';
import 'package:alnas_doctor/features/chat/chat_router.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final AppRouter _instance = AppRouter._internal();

  factory AppRouter() {
    return _instance;
  }

  AppRouter._internal();

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      /// Onboarding Router
      // ...OnboardingRouter.goRoutes,

      /// Auth Router
      ...AuthRouter.goRoutes,

      /// Home Router
      /// Home Router
      ...HomeRouter.goRoutes,

      /// Notifications Router
      // ...NotificationsRouter.goRoutes,

      /// Logout Router
      ...ProfileRouter.goRoutes,

      ...ChatRouter.goRoutes,
    ],
  );
}
