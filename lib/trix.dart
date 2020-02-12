library trix;

import 'package:trix/trix_exception.dart';

class Trix {
  static T required<T>(Map map, String key) {
    if (T == dynamic) {
      throw TrixException.dynamic(map, key);
    }

    if (map[key] == null) {
      throw TrixException('Field $key is required', map, key);
    }

    final value = map[key];
    if (value is! T) {
      throw TrixException.wrongType(map, key, '$T', '${value.runtimeType}');
    }
    return value as T;
  }

  static T requiredFunc<T>(Map map, String key, Function func) {
    if (T == dynamic) {
      throw TrixException.dynamic(map, key);
    }

    if (map[key] == null) {
      throw TrixException.required(map, key);
    }

    final value = func(map[key]);
    if (value == null) {
      throw TrixException.funcRequired(map, key);
    }

    if (value is! T) {
      throw TrixException.funcWrongType(map, key, '$T', '${value.runtimeType}');
    }
    return value as T;
  }

  static T optional<T>(Map map, String key) {
    if (T == dynamic) {
      throw TrixException.dynamic(map, key);
    }

    final value = map[key];
    if (value == null) {
      return null;
    }

    if (value is! T) {
      throw TrixException.wrongType(map, key, '$T', '${value.runtimeType}');
    }
    return value as T;
  }

  static T optionalFunc<T>(Map map, String key, Function func) {
    if (T == dynamic) {
      throw TrixException.dynamic(map, key);
    }

    if (map[key] == null) {
      return null;
    }

    final value = func(map[key]);
    if (value != null && value is! T) {
      throw TrixException.funcWrongType(map, key, '$T', '${value.runtimeType}');
    }
    return value as T;
  }
}
