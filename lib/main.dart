import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_exports.dart';
import 'core/services/storage_service.dart' as storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await storage.StorageService().initialize();
  NetworkService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vehicle Site Support',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: _getInitialRoute(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }

  String _getInitialRoute() {
    // Always start with login route
    return '/login';
  }
}
