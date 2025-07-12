class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // App Configuration
  static const String appName = 'Vehicle Site Support';
  static const String version = '1.0.0';

  // Error Messages
  static const String networkError = 'Network connection error';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'Unknown error occurred';
}
