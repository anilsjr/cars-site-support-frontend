import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/responsive_widgets.dart';
import '../../../core/utils/responsive.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            // Profile header section
            ResponsiveLayoutBuilder(
              builder: (context, screenType, width) {
                final avatarRadius = Responsive.getResponsiveValue(
                  context,
                  mobile: 50.0,
                  tablet: 60.0,
                  desktop: 70.0,
                );

                return Column(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      child: Icon(Icons.person, size: avatarRadius * 0.8),
                    ),
                    SizedBox(
                      height: Responsive.getResponsiveValue(
                        context,
                        mobile: 16.0,
                        tablet: 20.0,
                        desktop: 24.0,
                      ),
                    ),
                    Obx(
                      () => ResponsiveText(
                        controller.userName.value,
                        mobileFontSize: 20,
                        tabletFontSize: 24,
                        desktopFontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: Responsive.getResponsiveValue(
                        context,
                        mobile: 6.0,
                        tablet: 8.0,
                        desktop: 10.0,
                      ),
                    ),
                    Obx(
                      () => ResponsiveText(
                        controller.userEmail.value,
                        mobileFontSize: 14,
                        tabletFontSize: 16,
                        desktopFontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: Responsive.getResponsiveValue(
                context,
                mobile: 24.0,
                tablet: 30.0,
                desktop: 36.0,
              ),
            ),
            // Profile options list
            Expanded(
              child: ResponsiveLayoutBuilder(
                builder: (context, screenType, width) {
                  // On desktop, we can show options in a grid for better use of space
                  if (screenType == ResponsiveScreenType.desktop ||
                      screenType == ResponsiveScreenType.largeDesktop) {
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 4,
                      children: _buildProfileOptions(),
                    );
                  }

                  // On mobile and tablet, use a simple list
                  return ListView(children: _buildProfileOptions());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProfileOptions() {
    return [
      _buildProfileOption(
        icon: Icons.edit,
        title: 'Edit Profile',
        onTap: () {},
      ),
      _buildProfileOption(
        icon: Icons.security,
        title: 'Change Password',
        onTap: () {},
      ),
      _buildProfileOption(
        icon: Icons.notifications,
        title: 'Notifications',
        onTap: () {},
      ),
      _buildProfileOption(icon: Icons.dark_mode, title: 'Theme', onTap: () {}),
      _buildProfileOption(
        icon: Icons.help,
        title: 'Help & Support',
        onTap: () {},
      ),
      _buildProfileOption(icon: Icons.info, title: 'About', onTap: () {}),
    ];
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        return ResponsiveCard(
          margin: Responsive.getPadding(
            context,
            mobile: const EdgeInsets.symmetric(vertical: 4),
            tablet: const EdgeInsets.symmetric(vertical: 6),
            desktop: const EdgeInsets.symmetric(vertical: 8),
          ),
          child: ListTile(
            leading: Icon(icon),
            title: ResponsiveText(
              title,
              mobileFontSize: 16,
              tabletFontSize: 17,
              desktopFontSize: 18,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
