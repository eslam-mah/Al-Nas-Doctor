import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/core/config/assets_box.dart';
import 'package:alnas_doctor/features/authentication/view/widgets/custom_auth_text_field.dart';
import 'package:alnas_doctor/features/authentication/view_model/login_cubit/login_cubit.dart';
import 'package:alnas_doctor/features/home/view/views/home_view.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignInView extends StatefulWidget {
  static const String routeName = '/sign-in';
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _onSignIn(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
        username: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    // Provide the Cubit to the Widget Tree
    return Scaffold(
      backgroundColor: AlNasTheme.background,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            GoRouter.of(context).go(HomeView.routeName);
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.failure.message ?? 'Login Failed',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: AlNasTheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30.h),

                      // ── Logo ──
                      _buildLogo(),

                      SizedBox(height: 30.h),

                      // ── Welcome Text ──
                      _buildWelcomeSection(l10n),

                      SizedBox(height: 30.h),

                      // ── Email / Phone Field ──
                      CustomAuthTextField(
                        label: l10n.emailOrPhone,
                        hintText: l10n.emailOrPhoneHint,
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        // keyboardType: TextInputType.emailAddress, // Username might not be email
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.emailOrPhoneRequired;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),

                      // ── Password Field ──
                      CustomAuthTextField(
                        label: l10n.password,
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: _togglePasswordVisibility,
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AlNasTheme.grey40,
                            size: 22.sp,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.passwordRequired;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 30.h),

                      // ── Sign In Button ──
                      _buildSignInButton(context, l10n, state),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ───────────────────────────────────────────────
  // WIDGETS
  // ───────────────────────────────────────────────

  Widget _buildLogo() {
    return Container(
      width: 160.w,
      height: 160.w,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AlNasTheme.backgroundLight,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AlNasTheme.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(AssetsBox.logo, fit: BoxFit.cover),
    );
  }

  Widget _buildWelcomeSection(S l10n) {
    return Column(
      children: [
        Text(
          l10n.welcomeBack,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: AlNasTheme.grey100,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          l10n.signInSubtitle,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AlNasTheme.grey60,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context, S l10n, LoginState state) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: state is LoginLoading ? null : () => _onSignIn(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AlNasTheme.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AlNasTheme.primaryBlue.withValues(
            alpha: 0.6,
          ),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          elevation: 2,
          shadowColor: AlNasTheme.primaryBlue.withValues(alpha: 0.3),
        ),
        child: state is LoginLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                l10n.signIn,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
