import 'package:alnas_doctor/features/authentication/view/views/sign_in_view.dart';
import 'package:go_router/go_router.dart';

class AuthRouter {
  static List<GoRoute> goRoutes = [
    GoRoute(
      path: SignInView.routeName,
      builder: (context, state) => const SignInView(),
    ),
  ];
}
