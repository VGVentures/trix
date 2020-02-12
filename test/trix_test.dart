import 'package:flutter_test/flutter_test.dart';
import 'package:trix/trix.dart';
import 'package:trix/trix_exception.dart';

void main() {
  group('Trix', () {
    final map = {
      'id': 0,
      'string': 'hello',
      'number': 123,
      'complex': {'name': 'world'}
    };

    group('Optionals', () {
      test('throws if type is not specified', () {
        expect(
          () => Trix.optional(map, 'id'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Type must be specified for id, cannot be dynamic'),
          ),
        );
      });

      test('incorrect type', () {
        expect(
          () => Trix.optional<String>(map, 'id'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Field id is not expected type. Found int expected String.'),
          ),
        );
      });

      test('missing field', () {
        expect(Trix.optional<int>(map, 'bogus'), null);
      });

      test('valid value', () {
        expect(Trix.optional<int>(map, 'id'), 0);
      });

      test('wrong type with func', () {
        expect(
          () => Trix.optionalFunc<int>(map, 'complex', (json) => json['name']),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Field complex is not expected type. Found String expected int.'),
          ),
        );
      });

      test('throws if type not specified', () {
        expect(
          () => Trix.optionalFunc(map, 'complex', (json) => json['name']),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Type must be specified for complex, cannot be dynamic'),
          ),
        );
      });

      test('valid value with func', () {
        final value =
            Trix.optionalFunc<String>(map, 'complex', (json) => json['name']);
        expect(value, 'world');
      });
    });

    group('Required', () {
      test('throws if type not specified', () {
        expect(
          () => Trix.required(map, 'id'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Type must be specified for id, cannot be dynamic'),
          ),
        );
      });

      test('throws if required field is not present', () {
        expect(
          () => Trix.required<int>(map, 'bogus'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() == 'Field bogus is required'),
          ),
        );
      });

      test('throws if required field is wrong type', () {
        expect(
          () => Trix.required<String>(map, 'id'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Field id is not expected type. Found int expected String.'),
          ),
        );
      });

      test('valid value', () {
        expect(Trix.required<int>(map, 'id'), 0);
      });

      test('throws if required field is not present', () {
        expect(
          () => Trix.requiredFunc<int>(map, 'bogus', (json) => json['name']),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() == 'Field bogus is required'),
          ),
        );
      });

      test('throws if function result is not present', () {
        expect(
          () => Trix.requiredFunc<int>(map, 'complex', (json) => json['bogus']),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Failed to build int from required field complex'),
          ),
        );
      });

      test('throws if type not specified', () {
        expect(
          () => Trix.requiredFunc(map, 'complex', (json) => json['name']),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Type must be specified for complex, cannot be dynamic'),
          ),
        );
      });

      test('wrong type with func', () {
        expect(
          () => Trix.requiredFunc<int>(map, 'complex', (json) => json['name']),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Field complex is not expected type. Found String expected int.'),
          ),
        );
      });

      test('valid value with func', () {
        final value =
            Trix.optionalFunc<String>(map, 'complex', (json) => json['name']);
        expect(value, 'world');
      });
    });
  });
}
