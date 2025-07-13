import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../core/theme/app_theme.dart';
import 'package:dio/dio.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController(text: "ANIL05101");
  final passwordController = TextEditingController(text: "data@1234");

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  // Use cases - injected via dependency injection
  late final LoginUseCase _loginUseCase;

  @override
  void onInit() {
    super.onInit();
    // Get use cases from dependency injection
    _loginUseCase = Get.find<LoginUseCase>();
  }

  @override
  void onClose() {
    userIdController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateUserId(String? value) {
    if (value == null || value.isEmpty) {
      return 'User ID is required';
    }
    if (value.length < 8 || value.length > 100) {
      return 'User ID must be at least 8 characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 4 || value.length > 100) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  Future<void> login([BuildContext? context]) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      print('Starting login process...');

      // Use clean architecture - call login use case
      final user = await _loginUseCase.execute(
        userIdController.text,
        passwordController.text,
      );
      print('Login successful, user: ${user.firstName}');

      // Clear loading state immediately after login success
      isLoading.value = false;

      // Get navigation context
      final navContext = context ?? Get.context;
      print('Navigation context: $navContext, mounted: ${navContext?.mounted}');

      // Show success message before navigation using ScaffoldMessenger
      if (navContext != null && navContext.mounted) {
        ScaffoldMessenger.of(navContext).showSnackBar(
          SnackBar(
            content: Text('Login successful! Welcome, ${user.firstName}'),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Navigate to dashboard on successful login using go_router

      if (navContext != null) {
        print('Current route: ${GoRouterState.of(navContext).uri.path}');

        if (navContext.mounted) {
          print('Attempting to navigate to /dashboard');
          navContext.go('/dashboard');
          print('Navigation command sent');
        }
      } else {
        print('No valid context for navigation');
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.toString()}');
      isLoading.value = false;
      String errorMessage = 'Login failed';

      if (e.response?.statusCode == 401) {
        errorMessage = 'Invalid credentials';
      } else if (e.response?.statusCode == 422) {
        errorMessage = 'Invalid input data';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Server error';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Connection error';
      }

      // Show error message using ScaffoldMessenger if context is available
      final errorContext = context ?? Get.context;
      if (errorContext != null && errorContext.mounted) {
        ScaffoldMessenger.of(errorContext).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('General exception caught: ${e.toString()}');
      isLoading.value = false;

      // Show error message using ScaffoldMessenger if context is available
      final errorContext = context ?? Get.context;
      if (errorContext != null && errorContext.mounted) {
        ScaffoldMessenger.of(errorContext).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
