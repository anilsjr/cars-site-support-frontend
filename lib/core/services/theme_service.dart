import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_site_support_web/core/constants/app_constants.dart'
    show AppConstants;
import 'storage_service.dart';

class ThemeService extends GetxController {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final savedTheme = StorageService.getLocalStorage(AppConstants.themeKey);
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          _themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          _themeMode.value = ThemeMode.dark;
          break;
        default:
          _themeMode.value = ThemeMode.system;
      }
    } else {
      // Set default theme to light when no saved theme is found
      _themeMode.value = ThemeMode.light;
      // Save the default theme to localStorage
      StorageService.setLocalStorage(AppConstants.themeKey, 'light');
    }
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    _themeMode.value = themeMode;

    String themeModeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }

    StorageService.setLocalStorage(AppConstants.themeKey, themeModeString);
  }

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }
}
