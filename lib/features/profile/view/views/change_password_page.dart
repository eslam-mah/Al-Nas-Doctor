import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/core/custom_widgets/custom_primary_button.dart';
import 'package:alnas_doctor/features/authentication/view_model/change_password_cubit/change_password_cubit.dart';
import 'package:alnas_doctor/features/profile/view/widgets/custom_text_form_field.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String routeName = '/change-password';
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      backgroundColor: AlNasTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.changePassword,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AlNasTheme.textDark,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AlNasTheme.grey80,
            size: 20.r,
          ),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.passwordChangedSuccessfully),
                backgroundColor: AlNasTheme.green100,
              ),
            );
            GoRouter.of(context).pop();
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message ?? l10n.somethingWentWrong),
                backgroundColor: AlNasTheme.red100,
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                // Lock icon
                Center(
                  child: Container(
                    width: 80.r,
                    height: 80.r,
                    decoration: BoxDecoration(
                      color: AlNasTheme.blue20.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 40.r,
                      color: AlNasTheme.blue100,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                // Current password
                Text(
                  l10n.currentPassword,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AlNasTheme.grey80,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: _currentPasswordController,
                  hintText: l10n.enterCurrentPassword,
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_isCurrentVisible,
                  suffixIcon: _isCurrentVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onSuffixTap: () =>
                      setState(() => _isCurrentVisible = !_isCurrentVisible),
                  filled: true,
                  fillColor: Colors.white,
                  borderColor: AlNasTheme.grey20,
                ),
                SizedBox(height: 20.h),
                // New password
                Text(
                  l10n.newPassword,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AlNasTheme.grey80,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: _newPasswordController,
                  hintText: l10n.enterNewPassword,
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_isNewVisible,
                  suffixIcon: _isNewVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onSuffixTap: () =>
                      setState(() => _isNewVisible = !_isNewVisible),
                  filled: true,
                  fillColor: Colors.white,
                  borderColor: AlNasTheme.grey20,
                ),
                SizedBox(height: 20.h),
                // Confirm new password
                Text(
                  l10n.confirmNewPassword,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AlNasTheme.grey80,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  hintText: l10n.confirmNewPasswordHint,
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_isConfirmVisible,
                  suffixIcon: _isConfirmVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onSuffixTap: () =>
                      setState(() => _isConfirmVisible = !_isConfirmVisible),
                  filled: true,
                  fillColor: Colors.white,
                  borderColor: AlNasTheme.grey20,
                ),
                SizedBox(height: 40.h),
                // Submit button
                BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                  builder: (context, state) {
                    if (state is ChangePasswordLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomPrimaryButton(
                      text: l10n.save,
                      onTap: _onSubmit,
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final l10n = S.of(context);
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validation
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fieldRequired),
          backgroundColor: AlNasTheme.red100,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordsDoNotMatch),
          backgroundColor: AlNasTheme.red100,
        ),
      );
      return;
    }

    context.read<ChangePasswordCubit>().changePassword(
      oldPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
