import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late GetStorage _box;

  Future<void> initialize() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  // Token operations
  Future<void> saveToken(String token) async {
    await _box.write(AppConstants.tokenKey, token);
  }

  String? getToken() {
    return _box.read<String>(AppConstants.tokenKey);
  }

  Future<void> removeToken() async {
    await _box.remove(AppConstants.tokenKey);
  }

  // User data operations
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _box.write(AppConstants.userKey, userData);
  }

  Map<String, dynamic>? getUserData() {
    return _box.read<Map<String, dynamic>>(AppConstants.userKey);
  }

  Future<void> removeUserData() async {
    await _box.remove(AppConstants.userKey);
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
  }

  bool hasData(String key) {
    return _box.hasData(key);
  }
}
