class TrixException implements Exception {
  final String message;
  final Map map;
  final String key;

  TrixException(this.message, this.map, this.key);

  factory TrixException.dynamic(Map map, String key) {
    return TrixException(
        'Type must be specified for $key, cannot be dynamic', map, key);
  }

  factory TrixException.required(Map map, String key) {
    return TrixException('Field $key is required', map, key);
  }

  factory TrixException.funcRequired(Map map, String key) {
    return TrixException('A function result is required for $key', map, key);
  }

  factory TrixException.wrongType(
      Map map, String key, String expected, String found) {
    return TrixException(
        'Field $key is not expected type. Found $found expected $expected.',
        map,
        key);
  }

  factory TrixException.funcWrongType(
      Map map, String key, String expected, String found) {
    return TrixException(
        'Field $key is not expected type. Found $found expected $expected.',
        map,
        key);
  }

  @override
  String toString() {
    return message;
  }
}
