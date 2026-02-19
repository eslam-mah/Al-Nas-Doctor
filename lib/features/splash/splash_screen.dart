import 'package:alnas_doctor/core/config/assets_box.dart';
import 'package:alnas_doctor/core/services/http_service/user_session.dart';
import 'package:alnas_doctor/core/services/notification_service.dart';
import 'package:alnas_doctor/core/utils/pref_keys.dart';
import 'package:alnas_doctor/core/utils/shared_preferences_service.dart';
import 'package:alnas_doctor/features/authentication/view/views/sign_in_view.dart';
import 'package:alnas_doctor/features/home/view/views/home_view.dart';
import 'package:alnas_doctor/features/notifications/view_model/register_token_cubit/register_token_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Initialize Notification Service (permissions, listeners, token)
    await NotificationService().init();

    final prefs = await SharedPreferencesService.getInstance();
    final isFirstLaunch =
        prefs.getBool(PrefKeys.kFirstLaunch, defaultValue: true) ?? true;

    if (!mounted) return;

    // Try to restore user session
    final isLoggedIn = await UserSession.instance.loadSession();

    // Register FCM token with userId if logged in
    if (isLoggedIn) {
      _registerFcmToken(userId: UserSession.instance.userData?.id);
    }

    if (!mounted) return;

    if (isLoggedIn) {
      GoRouter.of(context).go(HomeView.routeName);
    } else {
      GoRouter.of(context).go(SignInView.routeName);
    }
  }

  /// Register the FCM token with the backend.
  void _registerFcmToken({int? userId}) {
    final notificationService = NotificationService();
    final fcmToken = notificationService.fcmToken;
    final deviceId = notificationService.deviceId;

    if (fcmToken != null &&
        fcmToken.isNotEmpty &&
        deviceId != null &&
        deviceId.isNotEmpty &&
        userId != null &&
        mounted) {
      context.read<RegisterTokenCubit>().registerToken(
        fcmToken: fcmToken,
        deviceId: deviceId,
        userId: userId,
      );
    }
  }

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
