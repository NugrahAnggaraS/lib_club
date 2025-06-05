class UnauthorizedError implements Exception {
  final String message;
  final String type;

  UnauthorizedError({required this.message, required this.type});

  @override
  String toString() =>
      'Akun Kamu $message, pastikan login menggunakan akun yang sudah pernah terdaftar';
}
