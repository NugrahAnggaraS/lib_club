class User {
  String userName;
  String firstName;
  String lastName;
  String email;
  String? token;

  User({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.token,
  });
}
