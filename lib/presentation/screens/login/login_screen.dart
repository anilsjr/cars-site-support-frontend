import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../widgets/responsive_widgets.dart';
import '../../../core/utils/responsive.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayoutBuilder(
        builder: (context, screenType, width) {
          return Center(
            child: SingleChildScrollView(
              padding: Responsive.getPadding(
                context,
                mobile: const EdgeInsets.all(24),
                tablet: const EdgeInsets.all(32),
                desktop: const EdgeInsets.all(48),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.getResponsiveValue(
                    context,
                    mobile: double.infinity,
                    tablet: 500,
                    desktop: 600,
                  ),
                ),
                child: ResponsiveCard(
                  elevation: Responsive.getResponsiveValue(
                    context,
                    mobile: 4.0,
                    tablet: 8.0,
                    desktop: 12.0,
                  ),
                  padding: Responsive.getPadding(
                    context,
                    mobile: const EdgeInsets.all(24),
                    tablet: const EdgeInsets.all(32),
                    desktop: const EdgeInsets.all(40),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ResponsiveText(
                        'Vehicle Site Support',
                        mobileFontSize: 24,
                        tabletFontSize: 28,
                        desktopFontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: Responsive.getResponsiveValue(
                          context,
                          mobile: 24.0,
                          tablet: 32.0,
                          desktop: 40.0,
                        ),
                      ),
                      Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controller.userIdController,
                              decoration: const InputDecoration(
                                labelText: 'User ID',
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: controller.validateUserId,
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
                              () => TextFormField(
                                controller: controller.passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordVisible.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed:
                                        controller.togglePasswordVisibility,
                                  ),
                                ),
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                validator: controller.validatePassword,
                              ),
                            ),
                            SizedBox(
                              height: Responsive.getResponsiveValue(
                                context,
                                mobile: 24.0,
                                tablet: 32.0,
                                desktop: 40.0,
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: Responsive.getResponsiveValue(
                                  context,
                                  mobile: 48.0,
                                  tablet: 52.0,
                                  desktop: 56.0,
                                ),
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.login,
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator()
                                      : ResponsiveText(
                                          'Login',
                                          mobileFontSize: 16,
                                          tabletFontSize: 18,
                                          desktopFontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
