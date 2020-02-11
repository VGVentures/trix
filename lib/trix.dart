library trix;

import 'package:trix/trix_exception.dart';

class Trix {
  static T required<T>(Map map, String key) {
    if (T == dynamic) {
      throw TrixException('Type must be specified, cannot be dynamic');
    }

    if (map[key] == null) {
      throw TrixException('Field $key is required');
    }
    final value = map[key];
    if (value is! T) {
      throw TrixException(
          'Field $key is not expected type. Found ${value.runtimeType} expected $T.');
    }
    return value as T;
  }

  static T requiredFunc<T>(Map map, String key, Function func) {
    if (T == dynamic) {
      throw TrixException('Type must be specified, cannot be dynamic');
    }

    if (map[key] == null) {
      throw TrixException('Field $key is required');
    }

    final value = func(map[key]);
    if (value == null) {
      throw TrixException('Function result is required');
    }

    if (value is! T) {
      throw TrixException(
          'Field $key is not expected type. Found ${value.runtimeType} expected $T.');
    }
    return value as T;
  }

  static T optional<T>(Map map, String key) {
    if (T == dynamic) {
      throw TrixException('Type must be specified, cannot be dynamic');
    }

    final value = map[key];
    if (value == null) {
      return null;
    }

    if (value is! T) {
      throw TrixException(
          'Field $key is not expected type. Found ${value.runtimeType} expected $T.');
    }
    return value as T;
  }

  static T optionalFunc<T>(Map map, String key, Function func) {
    if (T == dynamic) {
      throw TrixException('Type must be specified, cannot be dynamic');
    }

    if (map[key] == null) {
      return null;
    }

    final value = func(map[key]);
    if (value != null && value is! T) {
      throw TrixException(
          'Field $key is not expected type. Found ${value.runtimeType} expected $T.');
    }
    return value as T;
  }
}
