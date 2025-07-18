import 'package:get/get.dart';
import 'package:vehicle_site_support_web/core/constants/app_constants.dart'
    show AppConstants;
import 'storage_service.dart';

class AuthService extends GetxService {
  // Observable to track authentication state
  final RxBool _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  // Observable for user data
  final Rxn<Map<String, dynamic>> _userData = Rxn<Map<String, dynamic>>();
  Map<String, dynamic>? get userData => _userData.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Only initialize if not already initialized
    await checkAuthStatus();
  }

  /// Check if user is authenticated by verifying token and user data
  Future<bool> checkAuthStatus() async {
    try {
      final token = StorageService.getCookie(AppConstants.tokenKey);
      final userData = await StorageService.getLocalStorage(
        AppConstants.userDataKey,
      );

      if (token != null && token.isNotEmpty && userData != null) {
        _isAuthenticated.value = true;
        _userData.value = userData;
        return true;
      } else {
        _isAuthenticated.value = false;
        _userData.value = null;
        return false;
      }
    } catch (e) {
      _isAuthenticated.value = false;
      _userData.value = null;
      return false;
    }
  }

  /// Set authentication state after successful login
  Future<void> setAuthenticated(
    String token,
    Map<String, dynamic> userData,
  ) async {
    StorageService.setCookie(AppConstants.tokenKey, token);
    StorageService.setLocalStorage(AppConstants.userDataKey, userData);
    _isAuthenticated.value = true;
    _userData.value = userData;
  }

  /// Clear authentication state during logout
  Future<void> clearAuthentication() async {
    StorageService.removeCookie(AppConstants.tokenKey);
    StorageService.removeLocalStorage(AppConstants.userDataKey);
    _isAuthenticated.value = false;
    _userData.value = null;
  }

  /// Get current auth token
  Future<String?> getToken() async {
    return StorageService.getCookie(AppConstants.tokenKey);
  }
}
