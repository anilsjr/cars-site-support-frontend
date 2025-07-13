import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/services/network_service.dart';
import '../../../core/services/storage_service.dart';

class DashboardScreen extends StatefulWidget {
  final Widget child;

  const DashboardScreen({super.key, required this.child});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _isSmallScreen(context) ? _buildDrawer() : null,
      body: _isSmallScreen(context)
          ? widget.child
          : Row(
              children: [
                _buildSidebar(),
                Expanded(child: widget.child),
              ],
            ),
    );
  }

  bool _isSmallScreen(BuildContext context) {
    //testing
    return MediaQuery.of(context).size.width < 1500;
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 1,
      leading: _isSmallScreen(context)
          ? IconButton(
              icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            )
          : null,
      automaticallyImplyLeading: _isSmallScreen(context),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Image.asset(
            'assets/images/logo.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryMedium,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
          // User Profile
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: const AssetImage(
                  'assets/images/profile-img.png',
                ),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image load error
                },
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  final selected = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(1000, 70, 16, 0),
                  items: [
                    PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                      Icon(Icons.person, color: theme.colorScheme.onSurface),
                      const SizedBox(width: 8),
                      const Text('Profile'),
                      ],
                    ),
                    ),
                    PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                      Icon(Icons.logout, color: theme.colorScheme.onSurface),
                      const SizedBox(width: 8),
                      const Text('Logout'),
                      ],
                    ),
                    ),
                  ],
                  );
                  if (selected == 'logout') {
                  // Replace with your token retrieval logic
                  final token = await _getToken();
                  await _logout(token);
                  // Navigate to login or splash screen
                  context.go('/login');

                  }
                  // 'profile' does nothing
                },
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'John Doe',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SEC102345',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.dividerColor)),
      ),
      child: _buildNavigationItems(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: _buildNavigationItems(),
    );
  }

  Widget _buildNavigationItems() {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Column(
      children: [
        if (_isSmallScreen(context)) const SizedBox(height: 20),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _buildNavigationItem(
                icon: Icons.dashboard,
                title: 'Dashboard',
                route: '/dashboard',
                isSelected: currentLocation == '/dashboard',
              ),
              _buildNavigationItem(
                icon: Icons.assignment,
                title: 'Service Leads',
                route: '/service-leads',
                isSelected: currentLocation == '/service-leads',
              ),
              _buildNavigationItem(
                icon: Icons.support_agent,
                title: 'Service Ticket',
                route: '/service-ticket',
                isSelected: currentLocation == '/service-ticket',
              ),
              _buildNavigationItem(
                icon: Icons.work,
                title: 'Jobs Cards',
                route: '/jobs-cards',
                isSelected: currentLocation == '/jobs-cards',
              ),
              _buildNavigationItem(
                icon: Icons.task_alt,
                title: 'Daily Tasks',
                route: '/daily-tasks',
                isSelected: currentLocation == '/daily-tasks',
              ),
              _buildNavigationItem(
                icon: Icons.directions_car,
                title: 'Vehicles',
                route: '/vehicles',
                isSelected: currentLocation == '/vehicles',
              ),
            ],
          ),
        ),
        // Theme switch at the bottom
        _buildThemeSwitch(),
      ],
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? AppTheme.primaryMedium
              : theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppTheme.primaryMedium
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppTheme.primaryVeryLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          context.go(route);
          if (_isSmallScreen(context) &&
              _scaffoldKey.currentState?.isDrawerOpen == true) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Widget _buildThemeSwitch() {
    final theme = Theme.of(context);
    final themeService = Get.find<ThemeService>();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
      ),
      child: Obx(
        () => Row(
          children: [
            Icon(
              themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: AppTheme.primaryMedium,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Switch(
              value: themeService.isDarkMode,
              onChanged: (value) {
                themeService.changeTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
              activeColor: AppTheme.primaryMedium,
              activeTrackColor: AppTheme.primaryLight.withOpacity(0.5),
              inactiveThumbColor: theme.colorScheme.outline,
              inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ],
        ),
      ),
    );
  }
}
