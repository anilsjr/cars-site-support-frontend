import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universal_html/html.dart' as html;
import '../constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late GetStorage _box;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    webOptions: WebOptions(
      dbName: 'VehicleSiteSecureStorage',
      publicKey: 'VehicleSitePublicKey',
    ),
  );

  Future<void> initialize() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  // Token operations (using browser cookies)
  Future<void> saveToken(String token) async {
    _setCookie(AppConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    return _getCookie(AppConstants.tokenKey);
  }

  Future<void> removeToken() async {
    _removeCookie(AppConstants.tokenKey);
  }

  // User data operations (using secure storage)
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final jsonString = jsonEncode(userData);
    await _secureStorage.write(key: AppConstants.userKey, value: jsonString);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final jsonString = await _secureStorage.read(key: AppConstants.userKey);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> removeUserData() async {
    await _secureStorage.delete(key: AppConstants.userKey);
  }

  // Theme operations
  Future<void> saveThemeMode(String themeMode) async {
    await _box.write(AppConstants.themeKey, themeMode);
  }

  String? getThemeMode() {
    return _box.read<String>(AppConstants.themeKey);
  }

  // Generic operations
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> clearAll() async {
    await _box.erase();
    await _secureStorage.deleteAll();
  }

  bool hasData(String key) {
    return _box.hasData(key);
  }

  // Secure storage operations
  Future<void> writeSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<bool> hasSecureData(String key) async {
    return await _secureStorage.containsKey(key: key);
  }

  // Cookie helper methods
  bool hasToken() {
    return _getCookie(AppConstants.tokenKey) != null;
  }

  void _setCookie(String name, String value, {int? maxAgeInSeconds}) {
    final maxAge = maxAgeInSeconds ?? (7 * 24 * 60 * 60); // Default 7 days
    html.document.cookie =
        '$name=$value; '
        'path=/; '
        'max-age=$maxAge; '
        'secure; '
        'samesite=strict';
  }

  void _removeCookie(String name) {
    html.document.cookie =
        '$name=; '
        'path=/; '
        'expires=Thu, 01 Jan 1970 00:00:00 GMT; '
        'secure; '
        'samesite=strict';
  }

  String? _getCookie(String name) {
    final cookies = html.document.cookie?.split(';') ?? [];
    for (final cookie in cookies) {
      final parts = cookie.trim().split('=');
      if (parts.length == 2 && parts[0] == name) {
        return parts[1];
      }
    }
    return null;
  }
}
