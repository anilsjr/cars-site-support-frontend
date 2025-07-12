import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/dashboard/dashboard_content_pages.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/login',
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
            builder: (context, state) => const ServiceLeadsContent(),
          ),
          GoRoute(
            path: '/service-ticket',
            name: 'service-ticket',
            builder: (context, state) => const ServiceTicketContent(),
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
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
