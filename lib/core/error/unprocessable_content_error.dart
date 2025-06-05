class UnprocessableContentError implements Exception {
  final String message;
  final Map<String, List<String>>? invalidFields;

  UnprocessableContentError({required this.message, this.invalidFields});

  @override
  String toString() => invalidFields.toString();
}
