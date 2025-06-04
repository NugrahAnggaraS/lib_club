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
    return LoginModel(
      userName: json['account']['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      token: json['token'],
    );
  }
}
