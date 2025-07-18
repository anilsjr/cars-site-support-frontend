import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';
import 'package:vehicle_site_support_web/core/constants/app_constants.dart'
    show AppConstants, appName;

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/services/storage_service.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final StorageService storageService;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<User?> getCurrentUser() async {
    try {
      if (!kIsWeb) return null;

      // First check local storage
      return StorageService.getLocalStorage<User>(
        AppConstants.userDataKey,
        fromJson: (json) => UserModel.fromJson(json),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving user: $e');
      }
      throw Exception('Login failed');
    }
  }

  @override
  Future<User> login(String userIdOrEmail, String password) async {
    try {
      final user = await remoteDataSource.login(userIdOrEmail, password);

      if (kIsWeb) {
        if (user.accessToken != null) {
          StorageService.setCookie('auth_token', user.accessToken!);
        }
        StorageService.setLocalStorage(AppConstants.isAuthenticatedKey, 'true');

        final userDataForStorage = user.toJson()..remove('token');
        StorageService.setLocalStorage(
          AppConstants.userDataKey,
          userDataForStorage,
        );
      }
      return user;
    } catch (e) {
      if (kDebugMode) {
        print('Login error in LoginService: $e');
      }
      // if (context != null) {
      //   showToastification(context, e.message, type: ToastificationType.error);
      // }

      throw Exception('Login failed');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Call API logout
      await remoteDataSource.logout();
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      // Clear local storage
      StorageService.setLocalStorage(AppConstants.isAuthenticatedKey, 'false');
      StorageService.clearAuthStorage();
    }
  }

  // @override
  // Future<User> updateProfile(User user) async {
  //   try {
  //     final userModel = UserModel(
  //       id: user.id,
  //       userId: user.userId,
  //       email: user.email,
  //       firstName: user.firstName,
  //       lastName: user.lastName,
  //       mobileNo: user.mobileNo,
  //       isActive: user.isActive,
  //       isLocked: user.isLocked,
  //       createdAt: user.createdAt,
  //       updatedAt: user.updatedAt,
  //     );

  //     final updatedUser = await remoteDataSource.updateProfile(userModel);

  //     // Update local storage
  //     await storageService.saveUserData(updatedUser.toJson());

  //     return updatedUser;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> changePassword(String oldPassword, String newPassword) async {
  //   // This would typically call a different endpoint
  //   throw UnimplementedError('Change password not implemented yet');
  // }
}
