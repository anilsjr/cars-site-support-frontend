import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/network_service.dart';
import 'package:dio/dio.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController(text: 'ANIL05101');
  final passwordController = TextEditingController(text: 'data@1234');

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

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
    return null;
  }

  String? validatePassword(String? value) {
    return Validators.validatePassword(value);
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      // Make API call to localhost:3000/api/auth/login
      final response = await NetworkService().post(
        'api/auth/login',
        data: {
          'user_id': userIdController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // Save token if provided in response
        if (response.data['token'] != null) {
          await StorageService().saveToken(response.data['token']);
        }

        // Save user data
        await StorageService().saveUserData({
          'user_id': userIdController.text,
          'name': response.data['name'] ?? 'User',
        });

        Get.offAllNamed('/dashboard');
        Get.snackbar(
          'Success',
          'Login successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed';

      if (e.response?.statusCode == 401) {
        errorMessage = 'Invalid credentials';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Server error';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Connection error';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
