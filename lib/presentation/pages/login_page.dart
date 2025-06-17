import 'package:flutter/material.dart';
import 'package:lib_club/core/error/server_error.dart';
import 'package:lib_club/core/error/unauthorized_error.dart';
import 'package:lib_club/core/error/unprocessable_content_error.dart';
import 'package:lib_club/data/repositories/auth_repository_impl.dart';
import 'package:lib_club/data/datasources/local/auth_local_datasource.dart';
import 'package:lib_club/data/datasources/remote/auth_remote_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:lib_club/domain/repositories/auth_repository.dart';
import 'package:lib_club/domain/usecases/auth/login_user.dart';

class LoginPage extends StatefulWidget {
  final AuthRepository authRepository = AuthRepositoryImpl(
    remoteDatasource: AuthRemoteDatasource(client: http.Client()),
    localDatasource: AuthLocalDatasource(),
  );

  LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final LoginUser loginUser;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _usernameMessageError;
  String? _passwordMessageError;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submit() async {
    setState(() {
      _usernameMessageError = null;
      _passwordMessageError = null;
    });

    try {
      final userName = _usernameController.text;
      final password = _passwordController.text;
      await loginUser(userName, password);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Berhasil Login")));

      Navigator.pushNamed(context, '/home');
    } on UnprocessableContentError catch (error) {
      final fieldsError = error.invalidFields;
      setState(() {
        _usernameMessageError = fieldsError?['username']?.join(', ');
        _passwordMessageError = fieldsError?['password']?.join(', ');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("pastikan periksa inputan dengan benar")),
      );
    } on UnauthorizedError catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } on ServerError catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  void initState() {
    super.initState();
    loginUser = LoginUser(repository: widget.authRepository);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                  errorText: _usernameMessageError,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  errorText: _passwordMessageError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Login'),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Belum memiliki Akun? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      "click here",
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
