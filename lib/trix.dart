library trix;

import 'package:trix/trix_exception.dart';

class Trix {
  Trix._();

  static T required<T>({Map map, String key}) {
    if (T == dynamic) {
      throw TrixException('Type must be specified, cannot be dynamic');
    }
    final value = map[key];
    if (value == null) {
      throw TrixException('Field $key is required');
    }
    if (value is! T) {
      throw TrixException('Field $key is not expected type $T');
    }
    return value;
  }

  static T requiredFunc<T>({Map map, String key, Function func}) {
    if (map[key] == null) {
      throw TrixException('Field $key is required');
    }

    final value = func(map[key]);
    if (value == null) {
      throw TrixException('Function result is required');
    }
    if (value is! T) {
      throw TrixException('Field $key is not expected type $T');
    }
    return value;
  }

  static T optional<T>({Map map, String key}) {
    if (T == dynamic) {
      throw TrixException('Type must be specified, cannot be dynamic');
    }
    final value = map[key];
    if (value != null && value is! T) {
      throw TrixException('Field $key is not expected type $T');
    }
    return value;
  }

  static T optionalFunc<T>({Map map, String key, Function func}) {
    if (map[key] == null) {
      return null;
    }

    final value = func(map[key]);
    if (value != null && value is! T) {
      throw TrixException('Field $key is not expected type $T');
    }
    return value;
  }
}
