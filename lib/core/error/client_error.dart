class ClientError implements Exception {
  final String message;
  final Map<String, List<String>>? invalidFields;

  ClientError({required this.message, this.invalidFields});
}
