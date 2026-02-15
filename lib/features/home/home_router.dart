import 'package:alnas_doctor/features/home/view_model/get_all_patients/get_all_patients_cubit.dart';
import 'package:alnas_doctor/features/home/view_model/search_patients/search_patients_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'view/views/home_view.dart';

class HomeRouter {
  static List<GoRoute> goRoutes = [
    GoRoute(
      path: HomeView.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => GetAllPatientsCubit()),
          BlocProvider(create: (context) => SearchPatientsCubit()),
        ],
        child: const HomeView(),
      ),
    ),
  ];
}
