import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/user_model.dart';
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
  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    // Get use cases from dependency injection
    _loginUseCase = Get.find<LoginUseCase>();
    _authService = Get.find<AuthService>();
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
      // Get navigation context early to avoid async gaps
      final navContext = context ?? Get.context;

      // Use clean architecture - call login use case
      final user = await _loginUseCase.execute(
        userIdController.text,
        passwordController.text,
      );

      // Update authentication state in AuthService
      await _authService.setAuthenticated(
        user.accessToken ?? '',
        (user as UserModel).toJson(),
      );

      // Clear loading state immediately after login success
      isLoading.value = false;

      // Show success message before navigation using ScaffoldMessenger
      if (navContext != null && navContext.mounted) {
        ScaffoldMessenger.of(navContext).showSnackBar(
          SnackBar(
            content: Text('Login successful! Welcome, ${user.firstName}'),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to dashboard on successful login
        navContext.go('/dashboard');
      }
    } on DioException catch (e) {
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
