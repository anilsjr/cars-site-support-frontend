import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);

  Future<User> execute(String userIdOrEmail, String password) async {
    if (userIdOrEmail.isEmpty || password.isEmpty) {
      throw Exception('User ID/Email and password cannot be empty');
    }

    return await repository.login(userIdOrEmail, password);
  }
}

class LogoutUseCase {
  final UserRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() async {
    await repository.logout();
  }
}

class GetCurrentUserUseCase {
  final UserRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> execute() async {
    return await repository.getCurrentUser();
  }
}
