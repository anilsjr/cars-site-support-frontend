import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: _isSmallScreen(context)
          ? IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
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
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'LOGO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SEC102345',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
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
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: _buildNavigationItems(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(child: _buildNavigationItems());
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
      ],
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.blue.shade50,
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
}
