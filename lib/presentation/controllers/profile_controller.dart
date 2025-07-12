import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class ProfileController extends GetxController {
  final RxString userName = 'Demo User'.obs;
  final RxString userEmail = 'demo@example.com'.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final userData = StorageService().getUserData();
    if (userData != null) {
      userName.value = userData['name'] ?? 'Demo User';
      userEmail.value = userData['email'] ?? 'demo@example.com';
    }
  }

  Future<void> logout() async {
    try {
      await StorageService().removeToken();
      await StorageService().removeUserData();
      Get.offAllNamed('/login');
      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
