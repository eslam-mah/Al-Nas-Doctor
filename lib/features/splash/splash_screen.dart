import 'package:alnas_doctor/core/config/assets_box.dart';
import 'package:alnas_doctor/core/services/http_service/user_session.dart';
import 'package:alnas_doctor/core/utils/pref_keys.dart';
import 'package:alnas_doctor/core/utils/shared_preferences_service.dart';
import 'package:alnas_doctor/features/authentication/view/views/sign_in_view.dart';
import 'package:alnas_doctor/features/home/view/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
        );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          await _initAndNavigate();
        });
      }
    });
  }

  Future<void> _initAndNavigate() async {
    final prefs = await SharedPreferencesService.getInstance();
    final isFirstLaunch =
        prefs.getBool(PrefKeys.kFirstLaunch, defaultValue: true) ?? true;

    if (!mounted) return;

    // Try to restore user session
    final isLoggedIn = await UserSession.instance.loadSession();

    // Register FCM token (with userId if logged in)
    // await _registerToken(
    //   userId: isLoggedIn ? UserSession.instance.userData?.id?.toString() : null,
    // );

    if (!mounted) return;

    if (isLoggedIn) {
      GoRouter.of(context).go(HomeView.routeName);
    } else {
      GoRouter.of(context).go(SignInView.routeName);
    }
  }

  // Future<void> _registerToken({String? userId}) async {
  //   try {
  //     final messaging = FirebaseMessaging.instance;
  //     final token = await messaging.getToken();

  //     if (token != null) {
  //       if (!mounted) return;

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
  //           userId: userId,
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _controller,
              child: Image.asset(
                AssetsBox.logoOnly,
                height: 80.h,
                width: 120.w,
              ),
            ),
            SlideTransition(
              position: _slideAnimation,
              child: Image.asset(
                AssetsBox.textOnly,
                height: 80.h,
                width: 120.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
