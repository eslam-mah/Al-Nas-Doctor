import 'package:alnas_doctor/features/authentication/view_model/change_password_cubit/change_password_cubit.dart';
import 'package:alnas_doctor/features/profile/view/views/change_password_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: ChangePasswordPage.routeName,
      builder: (context, state) => BlocProvider(
        create: (context) => ChangePasswordCubit(),
        child: const ChangePasswordPage(),
      ),
    ),
  ];
}
