import 'package:flutter/material.dart';
import 'package:lib_club/data/repositories/auth_repository_impl.dart';
import 'package:lib_club/data/datasources/local/auth_local_datasource.dart';
import 'package:lib_club/data/datasources/remote/auth_remote_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:lib_club/domain/repositories/auth_repository.dart';
import 'package:lib_club/domain/usecases/auth/login_user.dart';
import 'package:lib_club/presentation/pages/home_page.dart';

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

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final userName = _usernameController.text;
        final password = _passwordController.text;
        final user = await loginUser(userName, password);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Berhasil Login")));

        Navigator.pushNamed(context, '/home');
      } catch (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mohon pastikan data sudah valid")),
      );
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
          // <- TAMBAHKAN WIDGET FORM INI
          key: _formKey, // <- HUBUNGKAN DENGAN FORM KEY
          child: Column(
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
                  if (value == null || value.isEmpty) {
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
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
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
      ),
    );
  }
}
