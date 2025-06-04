import 'package:lib_club/domain/entities/user.dart';

class RegisterModel extends User {
  RegisterModel({
    required String userName,
    required String firstName,
    required String lastName,
    required String email,
  }) : super(
         userName: userName,
         firstName: firstName,
         lastName: lastName,
         email: email,
       );

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      userName: json['account']['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
}
