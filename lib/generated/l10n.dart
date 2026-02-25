// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to manage your page`
  String get signInSubtitle {
    return Intl.message(
      'Sign in to manage your page',
      name: 'signInSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get emailOrPhone {
    return Intl.message('Username', name: 'emailOrPhone', desc: '', args: []);
  }

  /// `eg: 123456789`
  String get emailOrPhoneHint {
    return Intl.message(
      'eg: 123456789',
      name: 'emailOrPhoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your username`
  String get emailOrPhoneRequired {
    return Intl.message(
      'Please enter your username',
      name: 'emailOrPhoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Please enter your password`
  String get passwordRequired {
    return Intl.message(
      'Please enter your password',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `My Patients`
  String get myPatients {
    return Intl.message('My Patients', name: 'myPatients', desc: '', args: []);
  }

  /// `Dr. Sarah`
  String get doctorName {
    return Intl.message('Dr. Sarah', name: 'doctorName', desc: '', args: []);
  }

  /// `Search by name or phone number or medical id...`
  String get searchHint {
    return Intl.message(
      'Search by name or phone number or medical id...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `TOTAL`
  String get total {
    return Intl.message('TOTAL', name: 'total', desc: '', args: []);
  }

  /// `CRITICAL`
  String get critical {
    return Intl.message('CRITICAL', name: 'critical', desc: '', args: []);
  }

  /// `REVIEWS`
  String get reviews {
    return Intl.message('REVIEWS', name: 'reviews', desc: '', args: []);
  }

  /// `REQUIRES ATTENTION`
  String get requiresAttention {
    return Intl.message(
      'REQUIRES ATTENTION',
      name: 'requiresAttention',
      desc: '',
      args: [],
    );
  }

  /// `STABLE PATIENTS`
  String get stablePatients {
    return Intl.message(
      'STABLE PATIENTS',
      name: 'stablePatients',
      desc: '',
      args: [],
    );
  }

  /// `High Risk`
  String get highRisk {
    return Intl.message('High Risk', name: 'highRisk', desc: '', args: []);
  }

  /// `Warning`
  String get warning {
    return Intl.message('Warning', name: 'warning', desc: '', args: []);
  }

  /// `Stable`
  String get stable {
    return Intl.message('Stable', name: 'stable', desc: '', args: []);
  }

  /// `Patients`
  String get patients {
    return Intl.message('Patients', name: 'patients', desc: '', args: []);
  }

  /// `Schedule`
  String get schedule {
    return Intl.message('Schedule', name: 'schedule', desc: '', args: []);
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `mg/dL`
  String get mgDl {
    return Intl.message('mg/dL', name: 'mgDl', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Logging out...`
  String get loggingOut {
    return Intl.message(
      'Logging out...',
      name: 'loggingOut',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get passwordChangedSuccessfully {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter current password`
  String get enterCurrentPassword {
    return Intl.message(
      'Enter current password',
      name: 'enterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter new password`
  String get confirmNewPasswordHint {
    return Intl.message(
      'Re-enter new password',
      name: 'confirmNewPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Chat Requests`
  String get chatRequests {
    return Intl.message(
      'Chat Requests',
      name: 'chatRequests',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message('Chats', name: 'chats', desc: '', args: []);
  }

  /// `No pending requests`
  String get noChatRequests {
    return Intl.message(
      'No pending requests',
      name: 'noChatRequests',
      desc: '',
      args: [],
    );
  }

  /// `No chats available`
  String get noChats {
    return Intl.message(
      'No chats available',
      name: 'noChats',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `Close Chat`
  String get closeChat {
    return Intl.message('Close Chat', name: 'closeChat', desc: '', args: []);
  }

  /// `Open Chat`
  String get openChat {
    return Intl.message('Open Chat', name: 'openChat', desc: '', args: []);
  }

  /// `Manage Your Conversations`
  String get manageYourConversation {
    return Intl.message(
      'Manage Your Conversations',
      name: 'manageYourConversation',
      desc: '',
      args: [],
    );
  }

  /// `Type a message...`
  String get typeAMessage {
    return Intl.message(
      'Type a message...',
      name: 'typeAMessage',
      desc: '',
      args: [],
    );
  }

  /// `No Messages Yet`
  String get noMessagesYet {
    return Intl.message(
      'No Messages Yet',
      name: 'noMessagesYet',
      desc: '',
      args: [],
    );
  }

  /// `Send a message to start the conversation`
  String get startConversation {
    return Intl.message(
      'Send a message to start the conversation',
      name: 'startConversation',
      desc: '',
      args: [],
    );
  }

  /// `Connecting to chat...`
  String get connectingToChat {
    return Intl.message(
      'Connecting to chat...',
      name: 'connectingToChat',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `Offline`
  String get offline {
    return Intl.message('Offline', name: 'offline', desc: '', args: []);
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Reconnecting...`
  String get reconnecting {
    return Intl.message(
      'Reconnecting...',
      name: 'reconnecting',
      desc: '',
      args: [],
    );
  }

  /// `Reconnecting to chat...`
  String get reconnectingToChat {
    return Intl.message(
      'Reconnecting to chat...',
      name: 'reconnectingToChat',
      desc: '',
      args: [],
    );
  }

  /// `Connection lost`
  String get connectionLost {
    return Intl.message(
      'Connection lost',
      name: 'connectionLost',
      desc: '',
      args: [],
    );
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message(
      'Disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Reconnect`
  String get reconnect {
    return Intl.message('Reconnect', name: 'reconnect', desc: '', args: []);
  }

  /// `Chat with`
  String get chatWith {
    return Intl.message('Chat with', name: 'chatWith', desc: '', args: []);
  }

  /// `Are you sure you want to close this chat?`
  String get closeChatConfirmation {
    return Intl.message(
      'Are you sure you want to close this chat?',
      name: 'closeChatConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Chat closed successfully`
  String get closeChatSuccess {
    return Intl.message(
      'Chat closed successfully',
      name: 'closeChatSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to close chat`
  String get closeChatFailed {
    return Intl.message(
      'Failed to close chat',
      name: 'closeChatFailed',
      desc: '',
      args: [],
    );
  }

  /// `This chat has been closed`
  String get chatClosed {
    return Intl.message(
      'This chat has been closed',
      name: 'chatClosed',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
