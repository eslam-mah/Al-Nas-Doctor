import 'package:alnas_doctor/core/utils/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'language_code';

  LanguageCubit() : super(const LanguageInitial()) {
    _loadSavedLanguage();
  }

  // Load saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferencesService.getInstance();
    final languageCode = prefs.getString(_languageKey, defaultValue: 'ar');

    if (languageCode != null) {
      emit(LanguageLoaded(Locale(languageCode)));
    }
  }

  // Change language and save to SharedPreferences
  Future<void> changeLanguage(Locale locale) async {
    final prefs = await SharedPreferencesService.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    emit(LanguageLoaded(locale));
  }

  // Toggle between Arabic and English
  Future<void> toggleLanguage() async {
    final currentLocale = state.locale;
    final newLocale = currentLocale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');

    await changeLanguage(newLocale);
  }
}
