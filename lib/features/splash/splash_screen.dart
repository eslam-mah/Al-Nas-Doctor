import 'package:alnas_doctor/core/config/assets_box.dart';
import 'package:alnas_doctor/core/utils/pref_keys.dart';
import 'package:alnas_doctor/core/utils/shared_preferences_service.dart';
import 'package:alnas_doctor/features/authentication/view/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1), // Starts below
          end: Offset.zero, // Ends at original position
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
        );

    _controller.forward();
    // _registerToken();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          // --- Use go_router for navigation ---
          // Navigate based on onboarding status
          final prefs = await SharedPreferencesService.getInstance();
          final isFirstLaunch =
              prefs.getBool(PrefKeys.kFirstLaunch, defaultValue: true) ?? true;

          if (mounted) {
            if (isFirstLaunch) {
              GoRouter.of(context).go(SignInView.routeName);
            } else {
              GoRouter.of(context).go(SignInView.routeName);
            }
          }
          // ------------------------------------
        });
      }
    });
  }

  // Future<void> _registerToken() async {
  //   try {
  //     final messaging = FirebaseMessaging.instance;
  //     final token = await messaging.getToken();

  //     if (token != null) {
  //       if (!mounted) return;

  //       // Get Device ID
  //       final deviceInfo = DeviceInfoPlugin();
  //       String? deviceId;

  //       if (Platform.isAndroid) {
  //         final androidInfo = await deviceInfo.androidInfo;
  //         deviceId = androidInfo.id;
  //       } else if (Platform.isIOS) {
  //         final iosInfo = await deviceInfo.iosInfo;
  //         deviceId = iosInfo.identifierForVendor;
  //       }

  //       if (deviceId != null && mounted) {
  //         context.read<RegisterTokenCubit>().registerToken(
  //           fcmToken: token,
  //           deviceId: deviceId,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Error registering token: $e');
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init is done in MyApp, so we can use the methods here.
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // --- LOGO (Responsive Height) ---
            FadeTransition(
              opacity: _controller,
              child: Image.asset(
                AssetsBox.logoOnly,
                height: 80.h,
                width: 120.w, // Use .h for responsive height
              ),
            ),
            // --- TEXT (Responsive Font Size) ---
            SlideTransition(
              position: _slideAnimation,
              child: Image.asset(
                AssetsBox.textOnly,
                height: 80.h,
                width: 120.w, // Use .h for responsive height
              ),
            ),
          ],
        ),
      ),
    );
  }
}
