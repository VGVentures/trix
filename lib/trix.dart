library trix;

import 'package:trix/trix_exception.dart';

class Trix {
  static T _getField<T>(Map map, String key, {bool required = false}) {
    if (T == dynamic) {
      throw TrixException.dynamic(map, key);
    }

    final field = map[key];
    if (field == null && required) {
      throw TrixException.required(map, key);
    }

    if (field != null && field is! T) {
      throw TrixException.wrongType(map, key, '$T', '${field.runtimeType}');
    }

    return map[key] as T;
  }

  static T required<T>(Map map, String key) {
    return _getField(map, key, required: true);
  }

  static T requiredMap<T>(Map map, String key, T Function(Map) func) {
    final value = func(_getField(map, key, required: true));
    if (value == null) {
      throw TrixException.funcRequired(map, key, '$T');
    }

    return value;
  }

  static T requiredList<T>(Map map, String key, T Function(List<Map>) func) {
    final value = func(_getField(map, key, required: true));
    if (value == null) {
      throw TrixException.funcRequired(map, key, '$T');
    }

    return value;
  }

  static T optional<T>(Map map, String key) {
    T value = _getField(map, key);
    if (value == null) {
      return null;
    }
    return value;
  }

  static T optionalMap<T>(Map map, String key, T Function(Map) func) {
    return func(_getField(map, key));
  }

  static T optionalList<T>(Map map, String key, T Function(List<Map>) func) {
    return func(_getField(map, key));
  }
}
