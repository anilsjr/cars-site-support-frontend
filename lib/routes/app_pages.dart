import 'package:get/get.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/data_list/data_list_screen.dart';
import '../presentation/bindings/dashboard_binding.dart';
import '../presentation/bindings/login_binding.dart';
import '../presentation/bindings/profile_binding.dart';
import '../presentation/bindings/data_list_binding.dart';

class AppPages {
  static const initial = '/dashboard';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/dashboard',
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: '/profile',
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/data-list',
      page: () => const DataListScreen(),
      binding: DataListBinding(),
    ),
  ];
}
