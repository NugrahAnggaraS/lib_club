import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lib_club/core/error/server_error.dart';
import 'package:lib_club/core/error/unauthorized_error.dart';
import 'package:lib_club/core/error/unprocessable_content_error.dart';
import 'package:lib_club/data/datasources/local/auth_local_datasource.dart';
import 'package:lib_club/data/datasources/remote/auth_remote_datasource.dart';
import 'package:lib_club/data/repositories/auth_repository_impl.dart';
import 'package:lib_club/domain/repositories/auth_repository.dart';
import 'package:lib_club/domain/usecases/auth/register_user.dart';

class RegistrationPage extends StatefulWidget {
  final AuthRepository authRepository = AuthRepositoryImpl(
    remoteDatasource: AuthRemoteDatasource(client: http.Client()),
    localDatasource: AuthLocalDatasource(),
  );

  RegistrationPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final RegisterUser registerUser;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _usernameMessageError;
  String? _firstnameMessageError;
  String? _lastnameMessageError;
  String? _emailMessageError;

  @override
  void initState() {
    super.initState();
    registerUser = RegisterUser(repository: widget.authRepository);
  }

  void _onSubmit() async {
    setState(() {
      _usernameMessageError = null;
      _firstnameMessageError = null;
      _lastnameMessageError = null;
      _emailMessageError = null;
    });

    try {
      final userName = _usernameController.text;
      final firstName = _firstNameController.text;
      final lastName = _lastnameController.text;
      final email = _emailController.text;
      await registerUser(userName, firstName, lastName, email);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Berhasil Registrasi")));

      Navigator.pushNamed(context, '/');
    } on UnprocessableContentError catch (error) {
      final invaliedFields = error.invalidFields;
      setState(() {
        _usernameMessageError = invaliedFields?['username']?.join(', ');
        _emailMessageError = invaliedFields?['email']?.join(', ');
        _firstnameMessageError = invaliedFields?['first_name']?.join(', ');
        _lastnameMessageError = invaliedFields?['last_name']?.join(', ');
      });
    } on UnauthorizedError catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } on ServerError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi Kesalahan Servers: ${error.message}")),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Studi Case Lib Club")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  errorText: _usernameMessageError,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Firstname',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  errorText: _firstnameMessageError,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastnameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Lastname',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  errorText: _lastnameMessageError,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  errorText: _emailMessageError,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _onSubmit, child: Text("Register")),

              Row(
                children: [
                  Text(
                    "Sudah memiliki akun?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
