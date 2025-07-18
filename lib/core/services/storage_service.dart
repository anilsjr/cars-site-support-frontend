import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:vehicle_site_support_web/app_exports.dart';

/// A utility class for managing web storage (cookies and localStorage)
class StorageService {
  // Constants for common storage keys

  // Cookie Methods
  /// Sets a cookie with the given name and value
  static void setCookie(
    String name,
    String value, {
    Duration? maxAge,
    String? domain,
    String path = '/',
    bool secure = true,
    String sameSite = 'Strict',
    // bool httpOnly = true, // REMOVE this, not usable from JS
  }) {
    if (!kIsWeb) return;

    final expires = maxAge ?? const Duration(hours: 1);
    final isLocalhost = html.window.location.hostname == 'localhost';
    final cookieDomain =
        domain ?? (isLocalhost ? 'localhost' : html.window.location.hostname);

    final cookie =
        '$name=$value; '
        'path=$path; '
        'domain=$cookieDomain; '
        'max-age=${expires.inSeconds}; '
        'SameSite=$sameSite; '
        // 'HttpOnly=$httpOnly; '
        '${secure && !isLocalhost ? '; Secure' : ''}';

    html.document.cookie = cookie;
  }

  /// Gets a cookie value by name
  static String? getCookie(String name) {
    if (!kIsWeb) return null;

    final cookies = html.document.cookie?.split(';');
    if (cookies == null) return null;

    for (var cookie in cookies) {
      final parts = cookie.trim().split('=');
      if (parts[0] == name && parts.length > 1) {
        return parts[1];
      }
    }
    return null;
  }

  /// Removes a cookie by name
  static void removeCookie(String name) {
    if (!kIsWeb) return;

    final isLocalhost = html.window.location.hostname == 'localhost';
    final domain = isLocalhost ? 'localhost' : html.window.location.hostname;

    html.document.cookie =
        '$name=; path=/; domain=$domain; expires=Thu, 01 Jan 1970 00:00:00 GMT';
    if (isLocalhost) {
      html.document.cookie =
          '$name=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT';
    }
  }

  // LocalStorage Methods
  /// Sets a value in localStorage
  static void setLocalStorage(String key, dynamic value) {
    if (!kIsWeb) return;

    try {
      final String serializedValue = value is String
          ? value
          : json.encode(value);
      html.window.localStorage[key] = serializedValue;
    } catch (e) {
      if (kDebugMode) {
        print('Error setting localStorage: $e');
      }
    }
  }

  /// Gets a value from localStorage
  static T? getLocalStorage<T>(
    String key, {
    T Function(Map<String, dynamic>)? fromJson,
  }) {
    if (!kIsWeb) return null;

    try {
      final value = html.window.localStorage[key];
      if (value == null) return null;

      if (T == String) return value as T;

      if (fromJson != null) {
        final Map<String, dynamic> jsonData = json.decode(value);
        return fromJson(jsonData);
      }

      return json.decode(value) as T;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting localStorage: $e');
      }
      return null;
    }
  }

  /// Removes a value from localStorage
  static void removeLocalStorage(String key) {
    if (!kIsWeb) return;
    html.window.localStorage.remove(key);
  }

  /// Clears all localStorage data
  static void clearLocalStorage() {
    if (!kIsWeb) return;
    html.window.localStorage.clear();
  }

  /// Clears all authentication related storage (both cookies and localStorage)
  static void clearAuthStorage() {
    if (!kIsWeb) return;

    removeCookie('auth_token');
    removeLocalStorage(AppConstants.userDataKey);
    removeLocalStorage(AppConstants.tokenKey);
    html.window.sessionStorage.clear();
  }

  /// Checks if a JWT token is expired by decoding its payload and reading the 'exp' claim.

  static bool isJwtExpired(String token) {
    try {
      final parts = token.split('.');

      if (parts.length != 3) return true; // Invalid token

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final exp = payload['exp'];

      if (exp == null) return true;

      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      return DateTime.now().isAfter(expiry);
    } catch (e) {
      // If any error occurs, treat the token as expired

      if (kDebugMode) {
        print('Error decoding JWT: $e');
      }

      return true;
    }
  }
}

// class StorageService {
//   static final StorageService _instance = StorageService._internal();
//   factory StorageService() => _instance;
//   StorageService._internal();

//   late GetStorage _box;
//   static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
//     aOptions: AndroidOptions(encryptedSharedPreferences: true),
//     webOptions: WebOptions(
//       dbName: 'VehicleSiteSecureStorage',
//       publicKey: 'VehicleSitePublicKey',
//     ),
//   );

//   Future<void> initialize() async {
//     await GetStorage.init();
//     _box = GetStorage();
//   }

//   // Token operations (using secure storage)
//   Future<void> saveToken(String token) async {
//     await _secureStorage.write(key: AppConstants.tokenKey, value: token);
//   }

//   Future<String?> getToken() async {
//     return await _secureStorage.read(key: AppConstants.tokenKey);
//   }

//   Future<void> removeToken() async {
//     await _secureStorage.delete(key: AppConstants.tokenKey);
//   }

//   // User data operations (using secure storage)
//   Future<void> saveUserData(Map<String, dynamic> userData) async {
//     final jsonString = jsonEncode(userData);
//     await _secureStorage.write(key: AppConstants.userKey, value: jsonString);
//   }

//   Future<Map<String, dynamic>?> getUserData() async {
//     final jsonString = await _secureStorage.read(key: AppConstants.userKey);
//     if (jsonString != null) {
//       return jsonDecode(jsonString) as Map<String, dynamic>;
//     }
//     return null;
//   }

//   Future<void> removeUserData() async {
//     await _secureStorage.delete(key: AppConstants.userKey);
//   }

//   // Theme operations
//   Future<void> saveThemeMode(String themeMode) async {
//     await _box.write(AppConstants.themeKey, themeMode);
//   }

//   String? getThemeMode() {
//     return _box.read<String>(AppConstants.themeKey);
//   }

//   // Generic operations
//   Future<void> write(String key, dynamic value) async {
//     await _box.write(key, value);
//   }

//   T? read<T>(String key) {
//     return _box.read<T>(key);
//   }

//   Future<void> remove(String key) async {
//     await _box.remove(key);
//   }

//   Future<void> clearAll() async {
//     await _box.erase();
//     await _secureStorage.deleteAll();
//   }

//   bool hasData(String key) {
//     return _box.hasData(key);
//   }

//   // Secure storage operations
//   Future<void> writeSecure(String key, String value) async {
//     await _secureStorage.write(key: key, value: value);
//   }

//   Future<String?> readSecure(String key) async {
//     return await _secureStorage.read(key: key);
//   }

//   Future<void> removeSecure(String key) async {
//     await _secureStorage.delete(key: key);
//   }

//   Future<bool> hasSecureData(String key) async {
//     return await _secureStorage.containsKey(key: key);
//   }
// }
