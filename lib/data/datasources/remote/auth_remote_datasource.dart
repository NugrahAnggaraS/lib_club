import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lib_club/core/error/server_error.dart';
import 'package:lib_club/core/error/unprocessable_content_error.dart';
import 'package:lib_club/core/error/unauthorized_error.dart';
import 'package:lib_club/core/util/validation_helper.dart';
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

    final response = await client.post(
      endpoint,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    switch (response.statusCode) {
      case 200:
        final responseBody = jsonDecode(response.body);
        return LoginModel.fromJson(responseBody);

      case 422:
        final responseBody = jsonDecode(response.body);
        final messageError = responseBody["message"];
        final invalidFields = ValidationHelper.parseInvalidFields(
          responseBody["invalid_fields"],
        );

        throw UnprocessableContentError(
          message: messageError,
          invalidFields: invalidFields,
        );

      case 401:
        final responseBody = jsonDecode(response.body);
        final messageError = responseBody['message'];
        final typeError = responseBody['type'];
        throw UnauthorizedError(message: messageError, type: typeError);

      default:
        throw ServerError(
          message:
              "Terjadi kesalahan pada server. Kami sedang mencoba memperbaikinya.",
        );
    }
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

    final response = await client.post(
      endpoint,
      headers: {"Content-Type": "application/json"},
      body: requestBody,
    );

    final responseBody = jsonDecode(response.body);
    print(responseBody);

    switch (response.statusCode) {
      case 200:
        return RegisterModel.fromJson(responseBody);

      case 422:
        final messageError = responseBody["message"];
        final invalidFields = ValidationHelper.parseInvalidFields(
          responseBody["invalid_fields"],
        );

        throw UnprocessableContentError(
          message: messageError,
          invalidFields: invalidFields,
        );

      case 401:
        final messageError = responseBody['message'];
        final typeError = responseBody['type'];
        throw UnauthorizedError(message: messageError, type: typeError);

      default:
        throw ServerError(
          message:
              "Terjadi kesalahan pada server. Kami sedang mencoba memperbaikinya.",
        );
    }
  }
}
