import 'package:flutter/material.dart';
import 'app_exports.dart';
import 'core/services/storage_service.dart' as storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await storage.StorageService().initialize();
  NetworkService().initialize();

  // Initialize dependency injection
  DependencyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vehicle Site Support',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
