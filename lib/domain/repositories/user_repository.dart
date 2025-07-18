import '../entities/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<User> login(String userIdOrEmail, String password);
  Future<void> logout();
  // Future<User> updateProfile(User user);
  // Future<void> changePassword(String oldPassword, String newPassword);
}
