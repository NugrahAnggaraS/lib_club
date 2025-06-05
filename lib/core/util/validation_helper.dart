class ValidationHelper {
  static Map<String, List<String>> parseInvalidFields(dynamic rawFields) {
    final Map<String, List<String>> result = {};
    if (rawFields is Map<String, dynamic>) {
      rawFields.forEach((key, value) {
        if (value is List) {
          result[key] = value.map((e) => e.toString()).toList();
        } else {
          result[key] = [value.toString()];
        }
      });
    }
    return result;
  }
}
