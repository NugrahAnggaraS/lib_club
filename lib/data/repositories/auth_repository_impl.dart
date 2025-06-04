import 'package:lib_club/data/datasources/remote/auth_remote_datasource.dart';
import 'package:lib_club/domain/entities/user.dart';
import 'package:lib_club/domain/repositories/auth_repository.dart';
import 'package:lib_club/data/datasources/local/auth_local_datasource.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<User> login(String userName, String password) async {
    final User user = await remoteDatasource.login(userName, password);
    final String token = user.token ?? '';

    localDatasource.saveToken(token);

    return user;
  }

  @override
  Future<User> register(
    String userName,
    String firstName,
    String lastName,
    String email,
  ) {
    return remoteDatasource.register(userName, firstName, lastName, email);
  }
}
