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
          () => Trix.optional(map: map, key: 'id'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.message == 'Type must be specified, cannot be dynamic'),
          ),
        );
      });

      test('incorrect type', () {
        expect(
          () => Trix.optional<String>(map: map, key: 'id'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.message == 'Field id is not expected type String'),
          ),
        );
      });

      test('missing field', () {
        expect(Trix.optional<int>(map: map, key: 'bogus'), null);
      });

      test('valid value', () {
        expect(Trix.optional<int>(map: map, key: 'id'), 0);
      });

      test('wrong type with func', () {
        expect(
          () => Trix.optionalFunc<int>(
              map: map,
              key: 'complex',
              func: (json) {
                return json['name'];
              }),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.message == 'Field complex is not expected type int'),
          ),
        );
      });

      test('valid value with func', () {
        final value = Trix.optionalFunc<String>(
            map: map,
            key: 'complex',
            func: (json) {
              return json['name'];
            });
        expect(value, 'world');
      });
    });

    group('Required', () {
      test('throws if type not specified', () {
        expect(
          () => Trix.required(map: map, key: 'id'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.message == 'Type must be specified, cannot be dynamic'),
          ),
        );
      });

      test('throws if required field is not present', () {
        expect(
          () => Trix.required<int>(map: map, key: 'bogus'),
          throwsA(
            predicate((e) =>
                e is TrixException && e.message == 'Field bogus is required'),
          ),
        );
      });

      test('throws if required field is wrong type', () {
        expect(
          () => Trix.required<String>(map: map, key: 'id'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.message == 'Field id is not expected type String'),
          ),
        );
      });

      test('valid value', () {
        expect(Trix.required<int>(map: map, key: 'id'), 0);
      });

      test('throws if required field is not present', () {
        expect(
          () => Trix.requiredFunc<int>(
              map: map,
              key: 'bogus',
              func: (json) {
                return json['name'];
              }),
          throwsA(
            predicate((e) =>
                e is TrixException && e.message == 'Field bogus is required'),
          ),
        );
      });

      test('throws if function result is not present', () {
        expect(
          () => Trix.requiredFunc<int>(
              map: map,
              key: 'complex',
              func: (json) {
                return json['bogus'];
              }),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.message == 'Function result is required'),
          ),
        );
      });

      test('wrong type with func', () {
        expect(
          () => Trix.requiredFunc<int>(
              map: map,
              key: 'complex',
              func: (json) {
                return json['name'];
              }),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.message == 'Field complex is not expected type int'),
          ),
        );
      });

      test('valid value with func', () {
        final value = Trix.optionalFunc<String>(
            map: map,
            key: 'complex',
            func: (json) {
              return json['name'];
            });
        expect(value, 'world');
      });
    });
  });
}
