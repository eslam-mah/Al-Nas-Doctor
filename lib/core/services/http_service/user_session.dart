import 'dart:convert';
import 'package:alnas_doctor/core/utils/pref_keys.dart';
import 'package:alnas_doctor/core/utils/shared_preferences_service.dart';
import 'package:alnas_doctor/features/authentication/data/models/user_model.dart';

/// Global singleton service to hold and persist the current user session.
/// Access from anywhere via [UserSession.instance].
class UserSession {
  UserSession._();
  static final UserSession instance = UserSession._();

  UserModel? _currentUser;

  /// The currently logged-in user model (includes token + patient data).
  UserModel? get currentUser => _currentUser;

  /// Shortcut to the patient data.
  UserData? get userData => _currentUser?.userData;

  /// The JWT token.
  String? get token => _currentUser?.token;

  /// Whether the user is logged in.
  bool get isLoggedIn => _currentUser != null && _currentUser!.token != null;

  /// Call this on login success — saves to memory + SharedPreferences.
  Future<void> saveSession(UserModel user) async {
    _currentUser = user;
    final prefs = await SharedPreferencesService.getInstance();
    await prefs.setBool(PrefKeys.kIsLoggedIn, true);
    await prefs.setString(PrefKeys.kToken, user.token ?? '');
    await prefs.setString(PrefKeys.kUserData, jsonEncode(user.toJson()));
  }

  /// Call this on app startup — restores session from SharedPreferences.
  Future<bool> loadSession() async {
    final prefs = await SharedPreferencesService.getInstance();
    final isLoggedIn =
        prefs.getBool(PrefKeys.kIsLoggedIn, defaultValue: false) ?? false;

    if (!isLoggedIn) return false;

    final userDataJson = prefs.getString(PrefKeys.kUserData);
    if (userDataJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(userDataJson);
        _currentUser = UserModel.fromJson(json);
        return true;
      } catch (e) {
        // Corrupted data, clear it
        await clearSession();
        return false;
      }
    }
    return false;
  }

  /// Call this on logout — clears memory + SharedPreferences.
  Future<void> clearSession() async {
    _currentUser = null;
    final prefs = await SharedPreferencesService.getInstance();
    await prefs.remove(PrefKeys.kIsLoggedIn);
    await prefs.remove(PrefKeys.kToken);
    await prefs.remove(PrefKeys.kUserData);
  }
}
