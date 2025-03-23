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
  String get energyMode {
    return Intl.message('Energy Mode', name: 'energyMode', desc: '', args: []);
  }

  /// `Energy Saving Mode`
  String get energySavingMode {
    return Intl.message(
      'Energy Saving Mode',
      name: 'energySavingMode',
      desc: '',
      args: [],
    );
  }

  /// `Super Energy Saving Mode`
  String get superEnergySavingMode {
    return Intl.message(
      'Super Energy Saving Mode',
      name: 'superEnergySavingMode',
      desc: '',
      args: [],
    );
  }

  /// `Sleep Mode`
  String get sleepMode {
    return Intl.message('Sleep Mode', name: 'sleepMode', desc: '', args: []);
  }

  /// `Login Here`
  String get loginHere {
    return Intl.message('Login Here', name: 'loginHere', desc: '', args: []);
  }

  /// `Welcome back you’ve been missed!`
  String get welcomeBack {
    return Intl.message(
      'Welcome back you’ve been missed!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message('Sign in', name: 'signIn', desc: '', args: []);
  }

  /// `Create new account`
  String get createNewAccount {
    return Intl.message(
      'Create new account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Or continue with`
  String get orContinueWith {
    return Intl.message(
      'Or continue with',
      name: 'orContinueWith',
      desc: '',
      args: [],
    );
  }

  /// `Face ID`
  String get faceId {
    return Intl.message('Face ID', name: 'faceId', desc: '', args: []);
  }

  /// `Two-Step Verification`
  String get twoStepVerification {
    return Intl.message(
      'Two-Step Verification',
      name: 'twoStepVerification',
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
  String get backupSettings {
    return Intl.message(
      'Backup Settings',
      name: 'backupSettings',
      desc: '',
      args: [],
    );
  }

  /// `Software Update`
  String get softwareUpdate {
    return Intl.message(
      'Software Update',
      name: 'softwareUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Help and Support`
  String get helpAndSupport {
    return Intl.message(
      'Help and Support',
      name: 'helpAndSupport',
      desc: '',
      args: [],
    );
  }

  /// `Delete My Account`
  String get deleteMyAccount {
    return Intl.message(
      'Delete My Account',
      name: 'deleteMyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create an account so you can easily control your home`
  String get createAccountDesc {
    return Intl.message(
      'Create an account so you can easily control your home',
      name: 'createAccountDesc',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message('Sign up', name: 'signUp', desc: '', args: []);
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordMismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Verify Your Identity`
  String get verifyYourIdentity {
    return Intl.message(
      'Verify Your Identity',
      name: 'verifyYourIdentity',
      desc: '',
      args: [],
    );
  }

  /// `We have sent an email to mo****@gmail.`
  String get sentEmailMessage {
    return Intl.message(
      'We have sent an email to mo****@gmail.',
      name: 'sentEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter Code`
  String get enterCode {
    return Intl.message('Enter Code', name: 'enterCode', desc: '', args: []);
  }

  /// `Enter Your Email to receive reset Code`
  String get enterEmailToReceiveCode {
    return Intl.message(
      'Enter Your Email to receive reset Code',
      name: 'enterEmailToReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueText {
    return Intl.message('Continue', name: 'continueText', desc: '', args: []);
  }

  /// `Enter Your New Password`
  String get enterNewPassword {
    return Intl.message(
      'Enter Your New Password',
      name: 'enterNewPassword',
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

  /// `Confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
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

  /// `Didn't receive a code?`
  String get didNotReceive {
    return Intl.message(
      'Didn\'t receive a code?',
      name: 'didNotReceive',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `is required`
  String get isRequired {
    return Intl.message('is required', name: 'isRequired', desc: '', args: []);
  }

  /// `must be at least`
  String get mustBeAtLeast {
    return Intl.message(
      'must be at least',
      name: 'mustBeAtLeast',
      desc: '',
      args: [],
    );
  }

  /// `characters`
  String get characters {
    return Intl.message('characters', name: 'characters', desc: '', args: []);
  }

  /// `cannot exceed`
  String get cannotExceed {
    return Intl.message(
      'cannot exceed',
      name: 'cannotExceed',
      desc: '',
      args: [],
    );
  }

  /// `contains invalid characters`
  String get containsInvalidCharacters {
    return Intl.message(
      'contains invalid characters',
      name: 'containsInvalidCharacters',
      desc: '',
      args: [],
    );
  }

  /// `has invalid formatting`
  String get hasInvalidFormatting {
    return Intl.message(
      'has invalid formatting',
      name: 'hasInvalidFormatting',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Invalid email format`
  String get invalidEmail {
    return Intl.message(
      'Invalid email format',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get passwordMinLength {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'passwordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot exceed 64 characters`
  String get passwordMaxLength {
    return Intl.message(
      'Password cannot exceed 64 characters',
      name: 'passwordMaxLength',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain:\n- At least 1 uppercase letter\n- At least 1 lowercase letter\n- At least 1 number\n- At least 1 special character`
  String get passwordRequirements {
    return Intl.message(
      'Password must contain:\n- At least 1 uppercase letter\n- At least 1 lowercase letter\n- At least 1 number\n- At least 1 special character',
      name: 'passwordRequirements',
      desc: '',
      args: [],
    );
  }

  /// `Original password is not provided`
  String get originalPasswordNotProvided {
    return Intl.message(
      'Original password is not provided',
      name: 'originalPasswordNotProvided',
      desc: '',
      args: [],
    );
  }

  /// `Code must contain numbers only`
  String get codeNumbersOnly {
    return Intl.message(
      'Code must contain numbers only',
      name: 'codeNumbersOnly',
      desc: '',
      args: [],
    );
  }

  /// `Take Control of\nYour Energy Usage`
  String get takeControl {
    return Intl.message(
      'Take Control of\nYour Energy Usage',
      name: 'takeControl',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Verify Your Email`
  String get verifyYourEmail {
    return Intl.message(
      'Verify Your Email',
      name: 'verifyYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code sent to your email`
  String get enterVerificationCode {
    return Intl.message(
      'Enter the verification code sent to your email',
      name: 'enterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Email verified successfully!`
  String get emailVerifiedSuccessfully {
    return Intl.message(
      'Email verified successfully!',
      name: 'emailVerifiedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message('Resend Code', name: 'resendCode', desc: '', args: []);
  }

  /// `Resend code in: {seconds}s`
  String resendCodeIn(Object seconds) {
    return Intl.message(
      'Resend code in: ${seconds}s',
      name: 'resendCodeIn',
      desc: '',
      args: [seconds],
    );
  }

  /// `First name is required`
  String get firstNameRequired {
    return Intl.message(
      'First name is required',
      name: 'firstNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Last name is required`
  String get lastNameRequired {
    return Intl.message(
      'Last name is required',
      name: 'lastNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 2 characters`
  String get nameMinLength {
    return Intl.message(
      'Name must be at least 2 characters',
      name: 'nameMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Name cannot exceed 50 characters`
  String get nameMaxLength {
    return Intl.message(
      'Name cannot exceed 50 characters',
      name: 'nameMaxLength',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emailRequired {
    return Intl.message(
      'Email is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email must not exceed 100 characters`
  String get emailMaxLength {
    return Intl.message(
      'Email must not exceed 100 characters',
      name: 'emailMaxLength',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get invalidEmailFormat {
    return Intl.message(
      'Invalid email format',
      name: 'invalidEmailFormat',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain an uppercase letter`
  String get passwordUppercaseRequired {
    return Intl.message(
      'Password must contain an uppercase letter',
      name: 'passwordUppercaseRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain a lowercase letter`
  String get passwordLowercaseRequired {
    return Intl.message(
      'Password must contain a lowercase letter',
      name: 'passwordLowercaseRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain a digit`
  String get passwordDigitsRequired {
    return Intl.message(
      'Password must contain a digit',
      name: 'passwordDigitsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required`
  String get confirmPasswordRequired {
    return Intl.message(
      'Confirm password is required',
      name: 'confirmPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code`
  String get pleaseEnterVerificationCode {
    return Intl.message(
      'Please enter the verification code',
      name: 'pleaseEnterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `The code must be at least 6 digits`
  String get codeMustBeAtLeast6Digits {
    return Intl.message(
      'The code must be at least 6 digits',
      name: 'codeMustBeAtLeast6Digits',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive a code?`
  String get didNtReceiveCode {
    return Intl.message(
      'Didn\'t receive a code?',
      name: 'didNtReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get Continue {
    return Intl.message('Continue', name: 'Continue', desc: '', args: []);
  }

  /// `Reports`
  String get Reports {
    return Intl.message('Reports', name: 'Reports', desc: '', args: []);
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
