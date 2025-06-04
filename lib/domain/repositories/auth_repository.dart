import 'package:lib_club/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String userName, String password);

  Future<User> register(
    String userName,
    String firstName,
    String lastName,
    String email,
  );
}
