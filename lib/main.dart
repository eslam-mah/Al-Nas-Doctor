import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/core/services/http_service/dio_helper.dart';
import 'package:alnas_doctor/core/services/language_cubit/language_cubit.dart';
import 'package:alnas_doctor/core/utils/app_router.dart';
import 'package:alnas_doctor/core/utils/shared_preferences_service.dart';
import 'package:alnas_doctor/features/authentication/view_model/login_cubit/login_cubit.dart';
import 'package:alnas_doctor/features/notifications/view_model/register_token_cubit/register_token_cubit.dart';
import 'package:alnas_doctor/firebase_options.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Force portrait mode only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Dio Helper
  DioHelper.init();

  // Initialize SharedPreferences service
  await SharedPreferencesService.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Create the router instance once to prevent recreation on language change
  static final _appRouter = AppRouter().router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterTokenCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          // Listen to LanguageCubit to get the current locale
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              return MaterialApp.router(
                routerConfig: _appRouter,
                locale: state.locale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,

                // Apply theme based on current locale
                theme: AlNasTheme.getLightTheme(state.locale),
              );
            },
          );
        },
      ),
    );
  }
}
