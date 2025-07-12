import 'package:dio/dio.dart';
import '../../core/services/network_service.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> getCurrentUser();
  Future<void> logout();
  Future<UserModel> updateProfile(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final NetworkService networkService;

  UserRemoteDataSourceImpl(this.networkService);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await networkService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else if (e.response?.statusCode == 422) {
        throw Exception('Invalid input data');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await networkService.get('/auth/user');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await networkService.post('/auth/logout');

      if (response.statusCode != 200) {
        throw Exception('Logout failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    try {
      final response = await networkService.put(
        '/auth/user',
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Update failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception('Invalid input data');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
