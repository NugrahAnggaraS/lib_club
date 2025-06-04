import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  saveToken(String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("token", token);
  }

  Future<String> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final String? token = sharedPreferences.getString('token');

    return token ?? "";
  }

  removeToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
  }
}
