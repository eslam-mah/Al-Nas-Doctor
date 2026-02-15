import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/core/services/language_cubit/language_cubit.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void showLanguageDialog(BuildContext context) {
  final currentLanguage = context
      .read<LanguageCubit>()
      .state
      .locale
      .languageCode;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Title
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AlNasTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.language_outlined,
                      color: AlNasTheme.primaryBlue,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      S.of(context).changeLanguage,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AlNasTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Arabic Option
              _LanguageOption(
                languageCode: 'ar',
                languageName: S.of(context).arabic,
                isSelected: currentLanguage == 'ar',
                onTap: () {
                  context.read<LanguageCubit>().changeLanguage(
                    const Locale('ar'),
                  );
                  GoRouter.of(dialogContext).pop();
                },
              ),
              SizedBox(height: 12.h),

              // English Option
              _LanguageOption(
                languageCode: 'en',
                languageName: S.of(context).english,
                isSelected: currentLanguage == 'en',
                onTap: () {
                  context.read<LanguageCubit>().changeLanguage(
                    const Locale('en'),
                  );
                  GoRouter.of(dialogContext).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _LanguageOption extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.languageCode,
    required this.languageName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AlNasTheme.primaryBlue.withValues(alpha: 0.08)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AlNasTheme.primaryBlue : Colors.transparent,
            width: 2.w,
          ),
        ),
        child: Row(
          children: [
            // Language Icon
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AlNasTheme.primaryBlue.withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.language,
                color: isSelected ? AlNasTheme.primaryBlue : Colors.grey,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),

            // Language Name
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AlNasTheme.primaryBlue
                      : AlNasTheme.textDark,
                ),
              ),
            ),

            // Radio Button
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AlNasTheme.primaryBlue : Colors.grey,
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AlNasTheme.primaryBlue,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
