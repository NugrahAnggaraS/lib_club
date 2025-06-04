import 'package:lib_club/domain/entities/user.dart';
import 'package:lib_club/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser({required this.repository});

  Future<User> call(String userName, String password) {
    return repository.login(userName, password);
  }
}
