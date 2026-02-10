import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AlNasTheme {
  // ============================================
  // BRAND COLOR PALETTE
  // ============================================

  // Red Family
  static const Color red100 = Color(0xFFF50D27);
  static const Color red80 = Color(0xFFFF4F52);
  static const Color red60 = Color(0xFFFF8C8C);
  static const Color red40 = Color(0xFFFFB9BA);
  static const Color red20 = Color(0xFFFFDFE0);

  // Yellow/Orange Family
  static const Color yellow100 = Color(0xFFF9A600);
  static const Color yellow80 = Color(0xFFFFB028);
  static const Color yellow60 = Color(0xFFFFC761);
  static const Color yellow40 = Color(0xFFFFDDA0);
  static const Color yellow20 = Color(0xFFFFF1D5);

  // Green Family
  static const Color green100 = Color(0xFF70B800);
  static const Color green80 = Color(0xFF90C406);
  static const Color green60 = Color(0xFFADD74D);
  static const Color green40 = Color(0xFFCCEB8C);
  static const Color green20 = Color(0xFFE6F7C7);

  // Blue Family
  static const Color blue100 = Color(0xFF00A3E6);
  static const Color blue80 = Color(0xFF33B5E5);
  static const Color blue60 = Color(0xFF66C8F0);
  static const Color blue40 = Color(0xFF99DBF5);
  static const Color blue20 = Color(0xFFCCEEFB);

  // Purple Family
  static const Color purple100 = Color(0xFF5B2481);
  static const Color purple80 = Color(0xFF7B4DAE);
  static const Color purple60 = Color(0xFF9B70C0);
  static const Color purple40 = Color(0xFFBCA5D6);
  static const Color purple20 = Color(0xFFE0D6ED);

  // Grey Family
  static const Color grey100 = Color(0xFF1A1A1A);
  static const Color grey80 = Color(0xFF333333);
  static const Color grey60 = Color(0xFF666666);
  static const Color grey40 = Color(0xFF999999);
  static const Color grey20 = Color(0xFFCCCCCC);
  static const Color grey10 = Color(0xFFE6E6E6);
  static const Color grey05 = Color(0xFFF2F2F2);

  // ============================================
  // SEMANTIC COLOR ALIASES (for backward compatibility)
  // ============================================

  // Primary Colors (keeping existing for compatibility)
  static const Color primaryBlue = blue100;
  static const Color primaryGreen = green80;
  static const Color primaryNewGreen = green100;
  static const Color secondaryRed = red100;
  static const Color secondaryYellow = yellow100;
  static const Color secondaryPurple = purple100;

  static const Color accentTeal = blue100;

  // Text Colors
  static const Color textDark = grey80;
  static const Color textMuted = grey60;
  static const Color textLight = grey80;

  // Status Colors
  static const Color error = red100;
  static const Color success = green100;
  static const Color warning = yellow100;
  static const Color info = blue100;

  // UI Colors
  static const Color divider = grey20;
  static const Color border = grey20;
  static const Color background = Color(0xFFF6F7FC);
  static const Color backgroundLight = Colors.white;

  // Dynamic theme that adapts to locale
  static ThemeData getLightTheme(Locale locale) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: locale.languageCode == 'ar'
          ? GoogleFonts.cairo().fontFamily
          : GoogleFonts.roboto().fontFamily,
      // MAIN COLOR SCHEME
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryBlue,
        onPrimary: Colors.white,
        secondary: primaryGreen,
        onSecondary: Colors.white,
        error: secondaryRed,
        onError: Colors.white,
        background: background,
        onBackground: textDark,
        surface: Colors.white,
        onSurface: textDark,
      ),

      scaffoldBackgroundColor: background,

      // APP BAR
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // BUTTONS
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: BorderSide(color: primaryBlue, width: 1.5.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // INPUT FIELDS
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryBlue, width: 1.8.w),
        ),
        labelStyle: TextStyle(color: textLight),
        hintStyle: TextStyle(color: textLight.withValues(alpha: 0.6)),
      ),

      // TEXT STYLES
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineLarge: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: TextStyle(fontSize: 16.sp, color: textDark),
        bodyMedium: TextStyle(fontSize: 14.sp, color: textLight),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textLight,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Keep the static theme for backward compatibility (uses English by default)
  static ThemeData get lightTheme => getLightTheme(const Locale('en'));
}
