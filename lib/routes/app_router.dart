import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../core/services/auth_service.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/dashboard/dashboard_content_pages.dart';
import '../presentation/screens/servicelead/servicelead_screen.dart';
import '../presentation/bindings/servicelead_binding.dart';
import '../presentation/screens/serviceticket/serviceticket_screen.dart';
import '../presentation/bindings/serviceticket_binding.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      try {
        final authService = Get.find<AuthService>();
        final isAuthenticated = await authService.checkAuthStatus();

        // List of protected routes that require authentication
        final protectedRoutes = [
          '/dashboard',
          '/service-leads',
          '/service-ticket',
          '/jobs-cards',
          '/daily-tasks',
          '/vehicles',
        ];

        final isProtectedRoute = protectedRoutes.any(
          (route) => state.matchedLocation.startsWith(route),
        );

        // If trying to access protected route without authentication
        if (isProtectedRoute && !isAuthenticated) {
          return '/login';
        }

        // If authenticated and trying to access login page, redirect to dashboard
        if (isAuthenticated && state.matchedLocation == '/login') {
          return '/dashboard';
        }

        return null; // No redirect needed
      } catch (e) {
        // If AuthService is not yet available, redirect to login
        return state.matchedLocation == '/login' ? null : '/login';
      }
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return DashboardScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardContent(),
          ),
          GoRoute(
            path: '/service-leads',
            name: 'service-leads',
            builder: (context, state) {
              // Initialize service lead dependencies
              ServiceLeadBinding().dependencies();
              return const ServiceLeadScreen();
            },
          ),
          GoRoute(
            path: '/service-ticket',
            name: 'service-ticket',
            builder: (context, state) {
              // Initialize service ticket dependencies
              ServiceTicketBinding().dependencies();
              return const ServiceTicketScreen();
            },
          ),
          GoRoute(
            path: '/jobs-cards',
            name: 'jobs-cards',
            builder: (context, state) => const JobsCardsContent(),
          ),
          GoRoute(
            path: '/daily-tasks',
            name: 'daily-tasks',
            builder: (context, state) => const DailyTasksContent(),
          ),
          GoRoute(
            path: '/vehicles',
            name: 'vehicles',
            builder: (context, state) => const VehiclesContent(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );

  static GoRouter get router => _router;
}
