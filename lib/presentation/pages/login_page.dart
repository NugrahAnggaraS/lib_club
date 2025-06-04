import 'package:flutter/material.dart';
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      print('Login dengan username: $username dan password: $password');
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Studi Case Lib Club")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.trim().length < 6) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
