import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../widgets/responsive_widgets.dart';
import '../../../core/utils/responsive.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveText(
              'Welcome to Vehicle Site Support',
              mobileFontSize: 20,
              tabletFontSize: 24,
              desktopFontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              height: Responsive.getResponsiveValue(
                context,
                mobile: 16.0,
                tablet: 20.0,
                desktop: 24.0,
              ),
            ),
            Expanded(
              child: ResponsiveGrid(
                mobileColumns: 1,
                tabletColumns: 2,
                desktopColumns: 3,
                largeDesktopColumns: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    title: 'Data List',
                    icon: Icons.list,
                    onTap: () => Get.toNamed('/data-list'),
                  ),
                  _buildDashboardCard(
                    title: 'Profile',
                    icon: Icons.person,
                    onTap: () => Get.toNamed('/profile'),
                  ),
                  _buildDashboardCard(
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () {},
                  ),
                  _buildDashboardCard(
                    title: 'Reports',
                    icon: Icons.bar_chart,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ResponsiveLayoutBuilder(
      builder: (context, screenType, width) {
        // Responsive icon size
        final iconSize = Responsive.getResponsiveValue(
          context,
          mobile: 40.0,
          tablet: 48.0,
          desktop: 56.0,
        );

        // Responsive font size
        final fontSize = Responsive.getResponsiveValue(
          context,
          mobile: 14.0,
          tablet: 16.0,
          desktop: 18.0,
        );

        return ResponsiveCard(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: iconSize, color: Get.theme.primaryColor),
              SizedBox(
                height: Responsive.getResponsiveValue(
                  context,
                  mobile: 8.0,
                  tablet: 12.0,
                  desktop: 16.0,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
