import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/core/custom_widgets/custom_primary_button.dart';
import 'package:alnas_doctor/core/services/http_service/user_session.dart';
import 'package:alnas_doctor/features/authentication/view/views/sign_in_view.dart';
import 'package:alnas_doctor/features/authentication/view_model/logout_cubit/logout_cubit.dart';
import 'package:alnas_doctor/features/profile/view/views/change_password_page.dart';
import 'package:alnas_doctor/features/profile/view/widgets/change_language_dialoge.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = UserSession.instance.userData;
    final patientName = patient?.fullName ?? '---';
    final l10n = S.of(context);

    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutLoading) {
          // Show loading overlay
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(
              child: Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 16.h),
                    Text(
                      l10n.loggingOut,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AlNasTheme.grey80,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is LogoutSuccess) {
          // Clear session and navigate to login
          UserSession.instance.clearSession();
          GoRouter.of(context).go(SignInView.routeName);
        } else if (state is LogoutFailure) {
          // Dismiss loading dialog if showing
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message ?? l10n.somethingWentWrong),
              backgroundColor: AlNasTheme.red100,
            ),
          );
        }
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Align(
                alignment: Intl.getCurrentLocale() == 'ar'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  l10n.profile,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AlNasTheme.textDark,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              CircleAvatar(
                radius: 50.r,
                backgroundColor: AlNasTheme.backgroundLight,
                child: Icon(
                  Icons.person,
                  size: 60.r,
                  color: AlNasTheme.primaryBlue,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                patientName,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AlNasTheme.textDark,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: AlNasTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                width: double.infinity,
                child: Column(
                  spacing: 16.h,
                  children: [
                    _ProfileListItem(
                      icon: FontAwesomeIcons.key,
                      text: l10n.changePassword,
                      onTap: () {
                        GoRouter.of(context).push(ChangePasswordPage.routeName);
                      },
                    ),
                    _ProfileListItem(
                      icon: FontAwesomeIcons.gear,
                      text: l10n.settings,
                      onTap: () {},
                    ),
                    _ProfileListItem(
                      icon: FontAwesomeIcons.language,
                      text: l10n.changeLanguage,
                      onTap: () {
                        showLanguageDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              CustomPrimaryButton(
                text: l10n.logout,
                onTap: () => _showLogoutConfirmation(context),
                color: AlNasTheme.secondaryRed.withValues(alpha: 0.4),
                icon: Icon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  color: AlNasTheme.secondaryRed.withValues(alpha: 0.7),
                  size: 24.r,
                ),
                height: 45.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final l10n = S.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          l10n.logout,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AlNasTheme.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          l10n.logoutConfirmation,
          style: TextStyle(fontSize: 14.sp, color: AlNasTheme.grey60),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: TextStyle(fontSize: 14.sp, color: AlNasTheme.grey60),
            ),
          ),
          SizedBox(width: 8.w),
          // Confirm button
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<LogoutCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AlNasTheme.secondaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            ),
            child: Text(
              l10n.confirm,
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileListItem extends StatelessWidget {
  const _ProfileListItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AlNasTheme.background,
            borderRadius: BorderRadius.circular(12.r),
          ),
          height: 56.h,
          child: Row(
            children: [
              Icon(icon, size: 24.r, color: AlNasTheme.primaryBlue),
              SizedBox(width: 10.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AlNasTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
