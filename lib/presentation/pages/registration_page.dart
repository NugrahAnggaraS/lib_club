import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    registerUser = RegisterUser(repository: widget.authRepository);
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userName = _usernameController.text;
        final firstName = _firstNameController.text;
        final lastName = _lastnameController.text;
        final email = _emailController.text;
        await registerUser(userName, firstName, lastName, email);
      } catch (error) {
        print(error.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("pastikan keseluruhan data sudah valid")),
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "pastikan username tidak kosong";
                } else if (value.length < 3) {
                  return "pastikan username panjangnya lebih dari 3";
                }

                return null;
              },
            ),

            TextFormField(
              controller: _firstNameController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "pastikan firstname tidak kosong";
                }

                return null;
              },
            ),

            TextFormField(
              controller: _lastnameController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "pastikan lastname tidak kosong";
                }

                return null;
              },
            ),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "pastikan lastname tidak kosong";
                } else if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Format email tidak valid';
                }

                return null;
              },
            ),

            ElevatedButton(onPressed: _onSubmit, child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
