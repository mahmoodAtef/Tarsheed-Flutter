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
    final name =
        (locale.countryCode?.isEmpty ?? false)
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

  /// `No route found`
  String get noRouteFound {
    return Intl.message(
      'No route found',
      name: 'noRouteFound',
      desc: '',
      args: [],
    );
  }

  /// `Create new account`
  String get createAccount {
    return Intl.message(
      'Create new account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Tarsheed`
  String get appName {
    return Intl.message('Tarsheed', name: 'appName', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Edit password, name, address, username, email`
  String get editPassNaAddUseEm {
    return Intl.message(
      'Edit password, name, address, username, email',
      name: 'editPassNaAddUseEm',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get security {
    return Intl.message('Security', name: 'security', desc: '', args: []);
  }

  /// `Face-ID, Two-Step Verification`
  String get faceTwoStVerification {
    return Intl.message(
      'Face-ID, Two-Step Verification',
      name: 'faceTwoStVerification',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language, Backup, Energy Modes...`
  String get lanBackEneMO {
    return Intl.message(
      'Language, Backup, Energy Modes...',
      name: 'lanBackEneMO',
      desc: '',
      args: [],
    );
  }

  /// `Rate Application`
  String get rateApplication {
    return Intl.message(
      'Rate Application',
      name: 'rateApplication',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message('Sign Out', name: 'signOut', desc: '', args: []);
  }

  /// `Energy Mode`
  String get energy_mode {
    return Intl.message('Energy Mode', name: 'energy_mode', desc: '', args: []);
  }

  /// `Energy Saving Mode`
  String get energy_saving_mode {
    return Intl.message(
      'Energy Saving Mode',
      name: 'energy_saving_mode',
      desc: '',
      args: [],
    );
  }

  /// `Super Energy Saving Mode`
  String get super_energy_saving_mode {
    return Intl.message(
      'Super Energy Saving Mode',
      name: 'super_energy_saving_mode',
      desc: '',
      args: [],
    );
  }

  /// `Sleep Mode`
  String get sleep_mode {
    return Intl.message('Sleep Mode', name: 'sleep_mode', desc: '', args: []);
  }

  /// `Login Here`
  String get login_here {
    return Intl.message('Login Here', name: 'login_here', desc: '', args: []);
  }

  /// `Welcome back you’ve been missed!`
  String get welcome_back {
    return Intl.message(
      'Welcome back you’ve been missed!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgot_password {
    return Intl.message(
      'Forgot your password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message('Sign in', name: 'sign_in', desc: '', args: []);
  }

  /// `Create new account`
  String get create_new_account {
    return Intl.message(
      'Create new account',
      name: 'create_new_account',
      desc: '',
      args: [],
    );
  }

  /// `Or continue with`
  String get or_continue_with {
    return Intl.message(
      'Or continue with',
      name: 'or_continue_with',
      desc: '',
      args: [],
    );
  }

  /// `first name`
  String get first_name {
    return Intl.message('first name', name: 'first_name', desc: '', args: []);
  }

  /// `last name`
  String get last_name {
    return Intl.message('last name', name: 'last_name', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Face ID`
  String get face_id {
    return Intl.message('Face ID', name: 'face_id', desc: '', args: []);
  }

  /// `Two-Step Verification`
  String get two_step_verification {
    return Intl.message(
      'Two-Step Verification',
      name: 'two_step_verification',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Backup Settings`
  String get backup_settings {
    return Intl.message(
      'Backup Settings',
      name: 'backup_settings',
      desc: '',
      args: [],
    );
  }

  /// `Software Update`
  String get software_update {
    return Intl.message(
      'Software Update',
      name: 'software_update',
      desc: '',
      args: [],
    );
  }

  /// `Help and Support`
  String get help_and_support {
    return Intl.message(
      'Help and Support',
      name: 'help_and_support',
      desc: '',
      args: [],
    );
  }

  /// `Delete My Account`
  String get delete_my_account {
    return Intl.message(
      'Delete My Account',
      name: 'delete_my_account',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get create_account {
    return Intl.message(
      'Create Account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Create an account so you can easily control your home`
  String get create_account_desc {
    return Intl.message(
      'Create an account so you can easily control your home',
      name: 'create_account_desc',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get sign_up {
    return Intl.message('Sign up', name: 'sign_up', desc: '', args: []);
  }

  /// `Already have an account?`
  String get already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get password_mismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'password_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `Verify Your Identity`
  String get verify_your_identity {
    return Intl.message(
      'Verify Your Identity',
      name: 'verify_your_identity',
      desc: '',
      args: [],
    );
  }

  /// `We have sent an email to mo****@gmail.`
  String get sent_email_message {
    return Intl.message(
      'We have sent an email to mo****@gmail.',
      name: 'sent_email_message',
      desc: '',
      args: [],
    );
  }

  /// `Enter Code`
  String get enter_code {
    return Intl.message('Enter Code', name: 'enter_code', desc: '', args: []);
  }

  /// `Enter Your Email to receive reset Code`
  String get enter_email_to_receive_code {
    return Intl.message(
      'Enter Your Email to receive reset Code',
      name: 'enter_email_to_receive_code',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_text {
    return Intl.message('Continue', name: 'continue_text', desc: '', args: []);
  }

  /// `Enter Your New Password`
  String get enter_new_password {
    return Intl.message(
      'Enter Your New Password',
      name: 'enter_new_password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirm_new_password {
    return Intl.message(
      'Confirm New Password',
      name: 'confirm_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Passwords do not match`
  String get passwords_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend_code {
    return Intl.message('Resend', name: 'resend_code', desc: '', args: []);
  }

  /// `Didn't receive a code?`
  String get didnot_receive {
    return Intl.message(
      'Didn\'t receive a code?',
      name: 'didnot_receive',
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
