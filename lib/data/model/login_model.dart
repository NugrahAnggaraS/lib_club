import 'package:lib_club/domain/entities/user.dart';

class LoginModel extends User {
  LoginModel({
    required String userName,
    required String firstName,
    required String lastName,
    required String email,
    required String token,
  }) : super(
         userName: userName,
         firstName: firstName,
         lastName: lastName,
         email: email,
         token: token,
       );

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final person = user['person'];

    return LoginModel(
      userName: user['username'],
      firstName: person['first_name'],
      lastName: person['last_name'],
      email: person['email'],
      token: json['token'],
    );
  }
}
