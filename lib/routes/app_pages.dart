import 'package:get/get.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/bindings/login_binding.dart';

class AppPages {
  static const initial = '/login';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
  ];
}
