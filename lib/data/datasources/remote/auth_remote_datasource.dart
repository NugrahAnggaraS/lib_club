import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lib_club/core/error/client_error.dart';
import 'package:lib_club/data/model/login_model.dart';
import 'package:lib_club/data/model/register_model.dart';
import 'package:lib_club/domain/entities/user.dart';

class AuthRemoteDatasource {
  final http.Client client;
  final baseUrl = "http://8.219.106.148:8086/api/v1";

  AuthRemoteDatasource({required this.client});

  Future<User> login(String userName, String password) async {
    final endpoint = Uri.parse('${baseUrl}/auth/login');
    final requestBody = jsonEncode({
      "username": userName,
      "password": password,
    });

    final response = await client.post(endpoint, body: requestBody);
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LoginModel.fromJson(responseBody);
    }

    final messageError = responseBody["message"];
    final invalidFieldsError = responseBody["invalid_fields"];

    throw ClientError(message: messageError, invalidFields: invalidFieldsError);
  }

  Future<User> register(
    String userName,
    String firstName,
    String lastName,
    String email,
  ) async {
    final endpoint = Uri.parse('${baseUrl}/auth/register');
    final requestBody = jsonEncode({
      "username": userName,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
    });

    final response = await client.post(endpoint, body: requestBody);
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RegisterModel.fromJson(responseBody);
    }

    final messageError = responseBody["message"];
    final invalidFieldsError = responseBody["invalid_fields"];

    throw ClientError(message: messageError, invalidFields: invalidFieldsError);
  }
}
