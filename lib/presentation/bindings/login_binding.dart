import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Login controller will get its dependencies from the global DI
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
