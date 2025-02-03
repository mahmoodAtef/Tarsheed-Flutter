class EndPoints {
  /// Authentication Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verify = '/auth/verify';
  static const String resendCode = '/auth/verification/resend/';
  static const String forgetPassword = '/auth/password/forget';
  static const String confirmForgotPasswordCode =
      '/auth/password/forget/verify';
  static const String resetPassword = '/auth/password/reset';
  static const String facebookLogin = '/auth/facebook/login';
  static const String googleLogin = '/auth/google/login';
}
