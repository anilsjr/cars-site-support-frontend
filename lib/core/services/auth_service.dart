import 'package:get/get.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final StorageService _storageService = StorageService();

  // Observable to track authentication state
  final RxBool _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  // Observable for user data
  final Rxn<Map<String, dynamic>> _userData = Rxn<Map<String, dynamic>>();
  Map<String, dynamic>? get userData => _userData.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await checkAuthStatus();
  }

  /// Check if user is authenticated by verifying token and user data
  Future<bool> checkAuthStatus() async {
    try {
      final token = await _storageService.getToken();
      final userData = await _storageService.getUserData();

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
    await _storageService.saveToken(token);
    await _storageService.saveUserData(userData);
    _isAuthenticated.value = true;
    _userData.value = userData;
  }

  /// Clear authentication state during logout
  Future<void> clearAuthentication() async {
    await _storageService.removeToken();
    await _storageService.removeUserData();
    _isAuthenticated.value = false;
    _userData.value = null;
  }

  /// Get current auth token
  Future<String?> getToken() async {
    return await _storageService.getToken();
  }
}
