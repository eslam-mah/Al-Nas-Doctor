import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/core/services/http_service/dio_helper.dart';
import 'package:alnas_doctor/core/services/language_cubit/language_cubit.dart';
import 'package:alnas_doctor/core/utils/app_router.dart';
import 'package:alnas_doctor/core/utils/shared_preferences_service.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize notification service and request permissions
  // await NotificationService().init();

  // // Load environment variables from .env fileF
  // await dotenv.load(fileName: ".env");
  // Force portrait mode only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Initialize Dio Helper (now has access to env variables)
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
  void initState() {
    super.initState();
    // Request notification permission after the app starts
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    // Wait a bit for the app to fully load
    await Future.delayed(const Duration(seconds: 1));

    // Check if permission is already granted
    final isGranted = await Permission.notification.isGranted;

    if (!isGranted) {
      // Request permission
      final status = await Permission.notification.request();

      // If user denied, you can show a dialog explaining why notifications are important
      if (status.isDenied || status.isPermanentlyDenied) {
        // Optionally show a dialog to explain why notifications are important
        // and guide user to settings if permanently denied
        if (status.isPermanentlyDenied) {
          // You can show a dialog here to guide user to app settings
          await openAppSettings();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LanguageCubit())],
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
