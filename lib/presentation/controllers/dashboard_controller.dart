import 'package:get/get.dart';

class DashboardController extends GetxController {
  void navigateToDataList() {
    Get.toNamed('/data-list');
  }

  void navigateToProfile() {
    Get.toNamed('/profile');
  }
}
