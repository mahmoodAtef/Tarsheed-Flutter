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
  static const String getAISuggestions = '/users/get/recomendations/';
  static const String getCategories = '/category/all';
  static const String getSensors = '/sensors';
  static const String getDevices = 'device/getAll/';
  static const String getRooms = '/room/getAll';

  static const String addDevice = '/device/create';
  static const String addRoom = '/room/create';
  static const String addSensor = '/sensor/create';

  static const String deleteDevice = '/device/delete/';
  static const String deleteRoom = '/room/delete';
  static const String deleteSensor = '/sensor/delete/';

  static const editDevice = '/device/update';
}
