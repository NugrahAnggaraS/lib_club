class ServerError implements Exception {
  final String message;
  ServerError({required this.message});

  @override
  String toString() => message;
}
