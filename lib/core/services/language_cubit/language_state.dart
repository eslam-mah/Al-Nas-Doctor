part of 'language_cubit.dart';

abstract class LanguageState {
  final Locale locale;

  const LanguageState(this.locale);
}

class LanguageInitial extends LanguageState {
  const LanguageInitial() : super(const Locale('en'));
}

class LanguageLoaded extends LanguageState {
  const LanguageLoaded(super.locale);
}
