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
      // First check local storage
      final userData = await storageService.getUserData();
      if (userData != null) {
        // Check if we have a valid token
        final token = await storageService.getToken();
        if (token != null) {
          return UserModel.fromJson(userData);
        }
      }

      // If not in local storage or no token, try to get from API
      final user = await remoteDataSource.getCurrentUser();
      await storageService.saveUserData(user.toJson());

      // Save the access token if available
      if (user.accessToken != null) {
        await storageService.saveToken(user.accessToken!);
      }

      return user;
    } catch (e) {
      // If API fails, return cached data if available and we have a token
      final token = await storageService.getToken();
      if (token != null) {
        final userData = await storageService.getUserData();
        if (userData != null) {
          return UserModel.fromJson(userData);
        }
      }
      return null;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);

      // Save user data and token to local storage
      await storageService.saveUserData(user.toJson());

      // Save the access token
      if (user.accessToken != null) {
        await storageService.saveToken(user.accessToken!);
      }

      return user;
    } catch (e) {
      rethrow;
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
      await storageService.removeToken();
      await storageService.removeUserData();
    }
  }

  @override
  Future<User> updateProfile(User user) async {
    try {
      final userModel = UserModel(
        id: user.id,
        userId: user.userId,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        mobileNo: user.mobileNo,
        isActive: user.isActive,
        isLocked: user.isLocked,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );

      final updatedUser = await remoteDataSource.updateProfile(userModel);

      // Update local storage
      await storageService.saveUserData(updatedUser.toJson());

      return updatedUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    // This would typically call a different endpoint
    throw UnimplementedError('Change password not implemented yet');
  }
}
