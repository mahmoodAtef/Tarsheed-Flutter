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

  /// `Reports`
  String get reports {
    return Intl.message('Reports', name: 'reports', desc: '', args: []);
  }

  /// `Error loading report data`
  String get errorLoadingReportData {
    return Intl.message(
      'Error loading report data',
      name: 'errorLoadingReportData',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Week`
  String get week {
    return Intl.message('Week', name: 'week', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Years`
  String get years {
    return Intl.message('Years', name: 'years', desc: '', args: []);
  }

  /// `Avg Usage`
  String get avgUsage {
    return Intl.message('Avg Usage', name: 'avgUsage', desc: '', args: []);
  }

  /// `Avg Cost`
  String get avgCost {
    return Intl.message('Avg Cost', name: 'avgCost', desc: '', args: []);
  }

  /// `Last Month Usage`
  String get lastMonthUsage {
    return Intl.message(
      'Last Month Usage',
      name: 'lastMonthUsage',
      desc: '',
      args: [],
    );
  }

  /// `Next Month Usage`
  String get nextMonthUsage {
    return Intl.message(
      'Next Month Usage',
      name: 'nextMonthUsage',
      desc: '',
      args: [],
    );
  }

  /// `Projected based on your usage history`
  String get projectedBasedOnUsageHistory {
    return Intl.message(
      'Projected based on your usage history',
      name: 'projectedBasedOnUsageHistory',
      desc: '',
      args: [],
    );
  }

  /// `You are now on the tier:`
  String get lowTierSystemMessage {
    return Intl.message(
      'You are now on the tier:',
      name: 'lowTierSystemMessage',
      desc: '',
      args: [],
    );
  }

  /// `Edit Password`
  String get editPassword {
    return Intl.message(
      'Edit Password',
      name: 'editPassword',
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

  /// `Password updated successfully`
  String get passwordUpdatedSuccessfully {
    return Intl.message(
      'Password updated successfully',
      name: 'passwordUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Update Password`
  String get updatePassword {
    return Intl.message(
      'Update Password',
      name: 'updatePassword',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted successfully`
  String get accountDeletedSuccess {
    return Intl.message(
      'Account deleted successfully',
      name: 'accountDeletedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Delete Your Account?`
  String get deleteAccountTitle {
    return Intl.message(
      'Delete Your Account?',
      name: 'deleteAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Once you submit a request to delete data, there's a 72-hour window during which you can cancel the process. During this period, you can cancel your deletion request in your Intuit Account. After the window, you'll no longer be able to cancel the request, and we're unable to retrieve your data.`
  String get deleteAccountMessage {
    return Intl.message(
      'Once you submit a request to delete data, there\'s a 72-hour window during which you can cancel the process. During this period, you can cancel your deletion request in your Intuit Account. After the window, you\'ll no longer be able to cancel the request, and we\'re unable to retrieve your data.',
      name: 'deleteAccountMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Devices running`
  String get devicesRunning {
    return Intl.message(
      'Devices running',
      name: 'devicesRunning',
      desc: '',
      args: [],
    );
  }

  /// `Energy consumption`
  String get energyConsumption {
    return Intl.message(
      'Energy consumption',
      name: 'energyConsumption',
      desc: '',
      args: [],
    );
  }

  /// `LOW`
  String get low {
    return Intl.message('LOW', name: 'low', desc: '', args: []);
  }

  /// `HIGH`
  String get high {
    return Intl.message('HIGH', name: 'high', desc: '', args: []);
  }

  /// `Medium`
  String get medium {
    return Intl.message('Medium', name: 'medium', desc: '', args: []);
  }

  /// `Very High`
  String get veryHigh {
    return Intl.message('Very High', name: 'veryHigh', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Tier 1 (0-50 kWh)`
  String get tier1 {
    return Intl.message('Tier 1 (0-50 kWh)', name: 'tier1', desc: '', args: []);
  }

  /// `Tier 2 (51-100 kWh)`
  String get tier2 {
    return Intl.message(
      'Tier 2 (51-100 kWh)',
      name: 'tier2',
      desc: '',
      args: [],
    );
  }

  /// `Tier 3 (101-200 kWh)`
  String get tier3 {
    return Intl.message(
      'Tier 3 (101-200 kWh)',
      name: 'tier3',
      desc: '',
      args: [],
    );
  }

  /// `Tier 4 (201-350 kWh)`
  String get tier4 {
    return Intl.message(
      'Tier 4 (201-350 kWh)',
      name: 'tier4',
      desc: '',
      args: [],
    );
  }

  /// `Tier 5 (351-650 kWh)`
  String get tier5 {
    return Intl.message(
      'Tier 5 (351-650 kWh)',
      name: 'tier5',
      desc: '',
      args: [],
    );
  }

  /// `Tier 6+ (651+ kWh)`
  String get tier6Plus {
    return Intl.message(
      'Tier 6+ (651+ kWh)',
      name: 'tier6Plus',
      desc: '',
      args: [],
    );
  }

  /// `You are now in Electricity consumption bracket number {tierNumber}`
  String currentTier(Object tierNumber) {
    return Intl.message(
      'You are now in Electricity consumption bracket number $tierNumber',
      name: 'currentTier',
      desc: '',
      args: [tierNumber],
    );
  }

  /// `Your Current Savings is`
  String get currentSavings {
    return Intl.message(
      'Your Current Savings is',
      name: 'currentSavings',
      desc: '',
      args: [],
    );
  }

  /// `which is in the`
  String get inThe {
    return Intl.message('which is in the', name: 'inThe', desc: '', args: []);
  }

  /// `tier`
  String get tier {
    return Intl.message('tier', name: 'tier', desc: '', args: []);
  }

  /// `Active Mode`
  String get activeMode {
    return Intl.message('Active Mode', name: 'activeMode', desc: '', args: []);
  }

  /// `Energy Saving`
  String get energySaving {
    return Intl.message(
      'Energy Saving',
      name: 'energySaving',
      desc: '',
      args: [],
    );
  }

  /// `Connected Devices`
  String get connectedDevices {
    return Intl.message(
      'Connected Devices',
      name: 'connectedDevices',
      desc: '',
      args: [],
    );
  }

  /// `View all`
  String get viewAll {
    return Intl.message('View all', name: 'viewAll', desc: '', args: []);
  }

  /// `No data found`
  String get noDataFound {
    return Intl.message(
      'No data found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `AI Suggestions`
  String get aiSuggestions {
    return Intl.message(
      'AI Suggestions',
      name: 'aiSuggestions',
      desc: '',
      args: [],
    );
  }

  /// `Current Month Usage`
  String get currentMonthUsage {
    return Intl.message(
      'Current Month Usage',
      name: 'currentMonthUsage',
      desc: '',
      args: [],
    );
  }

  /// `Sensors`
  String get sensors {
    return Intl.message('Sensors', name: 'sensors', desc: '', args: []);
  }

  /// `Please enter name`
  String get nameRequired {
    return Intl.message(
      'Please enter name',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Pin Number`
  String get pinNumberRequired {
    return Intl.message(
      'Please enter Pin Number',
      name: 'pinNumberRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please select room`
  String get roomRequired {
    return Intl.message(
      'Please select room',
      name: 'roomRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please select type`
  String get typeRequired {
    return Intl.message(
      'Please select type',
      name: 'typeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Sensor added successfully`
  String get sensorAdded {
    return Intl.message(
      'Sensor added successfully',
      name: 'sensorAdded',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profileUpdatedSuccessfully {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Add Device`
  String get addDevice {
    return Intl.message('Add Device', name: 'addDevice', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Please enter description`
  String get descriptionRequired {
    return Intl.message(
      'Please enter description',
      name: 'descriptionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Pin Number`
  String get pinNumber {
    return Intl.message('Pin Number', name: 'pinNumber', desc: '', args: []);
  }

  /// `Room`
  String get room {
    return Intl.message('Room', name: 'room', desc: '', args: []);
  }

  /// `No rooms available`
  String get noRoomsAvailable {
    return Intl.message(
      'No rooms available',
      name: 'noRoomsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `No categories available`
  String get noCategoriesAvailable {
    return Intl.message(
      'No categories available',
      name: 'noCategoriesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Please select category`
  String get categoryRequired {
    return Intl.message(
      'Please select category',
      name: 'categoryRequired',
      desc: '',
      args: [],
    );
  }

  /// `Device added successfully`
  String get deviceAddedSuccessfully {
    return Intl.message(
      'Device added successfully',
      name: 'deviceAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get priority {
    return Intl.message('Priority', name: 'priority', desc: '', args: []);
  }

  /// `Please select priority`
  String get priorityRequired {
    return Intl.message(
      'Please select priority',
      name: 'priorityRequired',
      desc: '',
      args: [],
    );
  }

  /// `Edit Device`
  String get editDevice {
    return Intl.message('Edit Device', name: 'editDevice', desc: '', args: []);
  }

  /// `Rooms`
  String get rooms {
    return Intl.message('Rooms', name: 'rooms', desc: '', args: []);
  }

  /// `Consumption`
  String get consumption {
    return Intl.message('Consumption', name: 'consumption', desc: '', args: []);
  }

  /// `Delete Device`
  String get deleteDevice {
    return Intl.message(
      'Delete Device',
      name: 'deleteDevice',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this device`
  String get confirmDeleteDevice {
    return Intl.message(
      'Are you sure you want to delete this device',
      name: 'confirmDeleteDevice',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete`
  String get yesDelete {
    return Intl.message('Yes, Delete', name: 'yesDelete', desc: '', args: []);
  }

  /// `Delete Device`
  String get deleteSensor {
    return Intl.message(
      'Delete Device',
      name: 'deleteSensor',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this sensor`
  String get confirmDeleteSensor {
    return Intl.message(
      'Are you sure you want to delete this sensor',
      name: 'confirmDeleteSensor',
      desc: '',
      args: [],
    );
  }

  /// `Sensor deleted successfully`
  String get sensorDeletedSuccessfully {
    return Intl.message(
      'Sensor deleted successfully',
      name: 'sensorDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Device deleted successfully`
  String get deviceDeletedSuccessfully {
    return Intl.message(
      'Device deleted successfully',
      name: 'deviceDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Add New Automation`
  String get addNewAutomation {
    return Intl.message(
      'Add New Automation',
      name: 'addNewAutomation',
      desc: '',
      args: [],
    );
  }

  /// `Automation added successfully`
  String get automationAddedSuccessfully {
    return Intl.message(
      'Automation added successfully',
      name: 'automationAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Automation Name`
  String get automationName {
    return Intl.message(
      'Automation Name',
      name: 'automationName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Automation Name`
  String get enterAutomationName {
    return Intl.message(
      'Enter Automation Name',
      name: 'enterAutomationName',
      desc: '',
      args: [],
    );
  }

  /// `Trigger`
  String get trigger {
    return Intl.message('Trigger', name: 'trigger', desc: '', args: []);
  }

  /// `When should this automation run?`
  String get whenShouldAutomationRun {
    return Intl.message(
      'When should this automation run?',
      name: 'whenShouldAutomationRun',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get schedule {
    return Intl.message('Schedule', name: 'schedule', desc: '', args: []);
  }

  /// `Run at specific time`
  String get runAtSpecificTime {
    return Intl.message(
      'Run at specific time',
      name: 'runAtSpecificTime',
      desc: '',
      args: [],
    );
  }

  /// `Sensor`
  String get sensor {
    return Intl.message('Sensor', name: 'sensor', desc: '', args: []);
  }

  /// `Run when sensor value changes`
  String get runWhenSensorValueChanges {
    return Intl.message(
      'Run when sensor value changes',
      name: 'runWhenSensorValueChanges',
      desc: '',
      args: [],
    );
  }

  /// `Select Time`
  String get selectTime {
    return Intl.message('Select Time', name: 'selectTime', desc: '', args: []);
  }

  /// `Select Sensor`
  String get selectSensor {
    return Intl.message(
      'Select Sensor',
      name: 'selectSensor',
      desc: '',
      args: [],
    );
  }

  /// `Trigger Value`
  String get triggerValue {
    return Intl.message(
      'Trigger Value',
      name: 'triggerValue',
      desc: '',
      args: [],
    );
  }

  /// `Conditions (Optional)`
  String get conditionsOptional {
    return Intl.message(
      'Conditions (Optional)',
      name: 'conditionsOptional',
      desc: '',
      args: [],
    );
  }

  /// `Additional conditions that must be met`
  String get additionalConditions {
    return Intl.message(
      'Additional conditions that must be met',
      name: 'additionalConditions',
      desc: '',
      args: [],
    );
  }

  /// `Device Condition`
  String get deviceCondition {
    return Intl.message(
      'Device Condition',
      name: 'deviceCondition',
      desc: '',
      args: [],
    );
  }

  /// `Sensor Condition`
  String get sensorCondition {
    return Intl.message(
      'Sensor Condition',
      name: 'sensorCondition',
      desc: '',
      args: [],
    );
  }

  /// `Select Device`
  String get selectDevice {
    return Intl.message(
      'Select Device',
      name: 'selectDevice',
      desc: '',
      args: [],
    );
  }

  /// `State/Value`
  String get stateValue {
    return Intl.message('State/Value', name: 'stateValue', desc: '', args: []);
  }

  /// `Add Device Condition`
  String get addDeviceCondition {
    return Intl.message(
      'Add Device Condition',
      name: 'addDeviceCondition',
      desc: '',
      args: [],
    );
  }

  /// `Add Sensor Condition`
  String get addSensorCondition {
    return Intl.message(
      'Add Sensor Condition',
      name: 'addSensorCondition',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get actions {
    return Intl.message('Actions', name: 'actions', desc: '', args: []);
  }

  /// `What should happen when triggered?`
  String get whatShouldHappen {
    return Intl.message(
      'What should happen when triggered?',
      name: 'whatShouldHappen',
      desc: '',
      args: [],
    );
  }

  /// `Device Action`
  String get deviceAction {
    return Intl.message(
      'Device Action',
      name: 'deviceAction',
      desc: '',
      args: [],
    );
  }

  /// `Notification Action`
  String get notificationAction {
    return Intl.message(
      'Notification Action',
      name: 'notificationAction',
      desc: '',
      args: [],
    );
  }

  /// `Turn On`
  String get turnOn {
    return Intl.message('Turn On', name: 'turnOn', desc: '', args: []);
  }

  /// `Turn Off`
  String get turnOff {
    return Intl.message('Turn Off', name: 'turnOff', desc: '', args: []);
  }

  /// `Notification Title`
  String get notificationTitle {
    return Intl.message(
      'Notification Title',
      name: 'notificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Notification Message`
  String get notificationMessage {
    return Intl.message(
      'Notification Message',
      name: 'notificationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Add Device Action`
  String get addDeviceAction {
    return Intl.message(
      'Add Device Action',
      name: 'addDeviceAction',
      desc: '',
      args: [],
    );
  }

  /// `Add Notification`
  String get addNotification {
    return Intl.message(
      'Add Notification',
      name: 'addNotification',
      desc: '',
      args: [],
    );
  }

  /// `Save Automation`
  String get saveAutomation {
    return Intl.message(
      'Save Automation',
      name: 'saveAutomation',
      desc: '',
      args: [],
    );
  }

  /// `Living Room Light`
  String get livingRoomLight {
    return Intl.message(
      'Living Room Light',
      name: 'livingRoomLight',
      desc: '',
      args: [],
    );
  }

  /// `Bedroom AC`
  String get bedroomAC {
    return Intl.message('Bedroom AC', name: 'bedroomAC', desc: '', args: []);
  }

  /// `Kitchen Fan`
  String get kitchenFan {
    return Intl.message('Kitchen Fan', name: 'kitchenFan', desc: '', args: []);
  }

  /// `Temperature Sensor`
  String get temperatureSensor {
    return Intl.message(
      'Temperature Sensor',
      name: 'temperatureSensor',
      desc: '',
      args: [],
    );
  }

  /// `Motion Sensor`
  String get motionSensor {
    return Intl.message(
      'Motion Sensor',
      name: 'motionSensor',
      desc: '',
      args: [],
    );
  }

  /// `Light Sensor`
  String get lightSensor {
    return Intl.message(
      'Light Sensor',
      name: 'lightSensor',
      desc: '',
      args: [],
    );
  }

  /// `Please add at least one action`
  String get pleaseAddAtLeastOneAction {
    return Intl.message(
      'Please add at least one action',
      name: 'pleaseAddAtLeastOneAction',
      desc: '',
      args: [],
    );
  }

  /// `Please select a time for schedule trigger`
  String get pleaseSelectTimeForSchedule {
    return Intl.message(
      'Please select a time for schedule trigger',
      name: 'pleaseSelectTimeForSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Please configure sensor trigger completely`
  String get pleaseConfigureSensorTrigger {
    return Intl.message(
      'Please configure sensor trigger completely',
      name: 'pleaseConfigureSensorTrigger',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get action {
    return Intl.message('Action', name: 'action', desc: '', args: []);
  }

  /// `No devices available`
  String get noDevicesAvailable {
    return Intl.message(
      'No devices available',
      name: 'noDevicesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No sensors available`
  String get noSensorsAvailable {
    return Intl.message(
      'No sensors available',
      name: 'noSensorsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Automation Status`
  String get automationStatus {
    return Intl.message(
      'Automation Status',
      name: 'automationStatus',
      desc: '',
      args: [],
    );
  }

  /// `Enabled`
  String get enabled {
    return Intl.message('Enabled', name: 'enabled', desc: '', args: []);
  }

  /// `Disabled`
  String get disabled {
    return Intl.message('Disabled', name: 'disabled', desc: '', args: []);
  }

  /// `Sensor value`
  String get sensorValue {
    return Intl.message(
      'Sensor value',
      name: 'sensorValue',
      desc: '',
      args: [],
    );
  }

  /// `Conditions`
  String get conditions {
    return Intl.message('Conditions', name: 'conditions', desc: '', args: []);
  }

  /// `No conditions set`
  String get noConditionsSet {
    return Intl.message(
      'No conditions set',
      name: 'noConditionsSet',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message('State', name: 'state', desc: '', args: []);
  }

  /// `Value`
  String get value {
    return Intl.message('Value', name: 'value', desc: '', args: []);
  }

  /// `Delete Automation`
  String get deleteAutomation {
    return Intl.message(
      'Delete Automation',
      name: 'deleteAutomation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this automation?`
  String get deleteAutomationConfirmation {
    return Intl.message(
      'Are you sure you want to delete this automation?',
      name: 'deleteAutomationConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Edit Automation`
  String get editAutomation {
    return Intl.message(
      'Edit Automation',
      name: 'editAutomation',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get devices {
    return Intl.message('Devices', name: 'devices', desc: '', args: []);
  }

  /// `Automations`
  String get automations {
    return Intl.message('Automations', name: 'automations', desc: '', args: []);
  }

  /// `My Home`
  String get myHome {
    return Intl.message('My Home', name: 'myHome', desc: '', args: []);
  }

  /// `Manage Your Devices`
  String get manageYourDevices {
    return Intl.message(
      'Manage Your Devices',
      name: 'manageYourDevices',
      desc: '',
      args: [],
    );
  }

  /// `Add, edit, or delete sensors to organize your devices`
  String get manageYourSensors {
    return Intl.message(
      'Add, edit, or delete sensors to organize your devices',
      name: 'manageYourSensors',
      desc: '',
      args: [],
    );
  }

  /// `Create, edit, or delete automations to control your devices based on conditions`
  String get manageYourAutomations {
    return Intl.message(
      'Create, edit, or delete automations to control your devices based on conditions',
      name: 'manageYourAutomations',
      desc: '',
      args: [],
    );
  }

  /// `Add, edit, or delete rooms to organize your devices and sensors`
  String get manageYourRooms {
    return Intl.message(
      'Add, edit, or delete rooms to organize your devices and sensors',
      name: 'manageYourRooms',
      desc: '',
      args: [],
    );
  }

  /// `Add Sensor`
  String get addSensor {
    return Intl.message('Add Sensor', name: 'addSensor', desc: '', args: []);
  }

  /// `Add Room`
  String get addRoom {
    return Intl.message('Add Room', name: 'addRoom', desc: '', args: []);
  }

  /// `Room Name`
  String get roomName {
    return Intl.message('Room Name', name: 'roomName', desc: '', args: []);
  }

  /// `Room Description`
  String get roomDescription {
    return Intl.message(
      'Room Description',
      name: 'roomDescription',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Room Details`
  String get roomDetails {
    return Intl.message(
      'Room Details',
      name: 'roomDetails',
      desc: '',
      args: [],
    );
  }

  /// `Room added successfully`
  String get roomAddedSuccessfully {
    return Intl.message(
      'Room added successfully',
      name: 'roomAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
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
