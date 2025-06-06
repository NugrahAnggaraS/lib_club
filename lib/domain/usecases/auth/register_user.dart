import 'package:lib_club/domain/entities/user.dart';
import 'package:lib_club/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser({required this.repository});

  Future<User> call(
    String userName,
    String firstName,
    String lastName,
    String email,
  ) {
    return repository.register(userName, firstName, lastName, email);
  }
}
