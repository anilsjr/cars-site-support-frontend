import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection and services
  await DependencyInjection.init();

  // Wait a bit to ensure all services are properly initialized
  await Future.delayed(const Duration(milliseconds: 100));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(
      () => MaterialApp.router(
        title: 'Vehicle Site Support',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeService.themeMode,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
