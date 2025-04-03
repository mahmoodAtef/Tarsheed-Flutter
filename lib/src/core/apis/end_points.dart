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
  static String updatePassword(String userId) =>
      '/users/$userId/changePassword';
  static const String facebookLogin = '/auth/facebook/login';
  static const String googleLogin = '/auth/google/login';

  /// Profile Endpoints
  static const String getProfile = '/users';
  static const String updateProfile = '/users';
  static const String deleteProfile = '/users';

  /// Dashboard Endpoints
  static const String getUsageReport = '/reports/';
  static const String getAISuggestions = '/reports/';
  static const String getCategories = '/categories';
  static const String getSensors = '/sensors';
  static const String getDevices = '/sensors';
  static const String getRooms = '/sensors';

  static const String addDevice = '/sensors';
  static const String addRoom = '/sensors';
  static const String addSensor = '/sensors';
}
