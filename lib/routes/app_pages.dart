import 'package:get/get.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/service_leads/service_leads_page.dart';
import '../presentation/bindings/login_binding.dart';
import '../presentation/bindings/service_leads_binding.dart';

class AppPages {
  static const initial = '/login';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/service-leads',
      page: () => const ServiceLeadsPage(),
      binding: ServiceLeadsBinding(),
    ),
  ];
}
