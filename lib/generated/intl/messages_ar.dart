// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟"),
    "emailOrPhone": MessageLookupByLibrary.simpleMessage("اسم المستخدم"),
    "emailOrPhoneHint": MessageLookupByLibrary.simpleMessage("eg: 123456789"),
    "emailOrPhoneRequired": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسم المستخدم",
    ),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "passwordRequired": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال كلمة المرور",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("سياسة الخصوصية"),
    "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signInSubtitle": MessageLookupByLibrary.simpleMessage(
      "سجل دخولك لإدارة صفحتك",
    ),
    "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "termsOfService": MessageLookupByLibrary.simpleMessage("شروط الخدمة"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("مرحباً بعودتك"),
  };
}
