import 'package:flutter_test/flutter_test.dart';
import 'package:trix/trix.dart';
import 'package:trix/trix_exception.dart';

class Test {
  final String hello;

  Test({this.hello});

  factory Test.fromJson(Map map) {
    return Test(hello: Trix.optional(map, 'hello'));
  }
}

void main() {
  group('Trix', () {
    final map = {
      'id': 0,
      'string': 'hello',
      'number': 123,
      'test': {'hello': 'world'},
      'testList': [
        {'hello': 'world'}
      ]
    };

    group('required', () {
      test('throws if type not specified', () {
        expect(
          () => Trix.required(map, 'id'),
          throwsA(predicate((e) =>
              e is TrixException &&
              e.toString() ==
                  'Type must be specified for (id), cannot be dynamic')),
        );
      });

      test('throws if required field is not present', () {
        expect(
          () => Trix.required<int>(map, 'bogus'),
          throwsA(predicate((e) =>
              e is TrixException &&
              e.toString() == 'Field (bogus) is required')),
        );
      });

      test('throws if required field is wrong type', () {
        expect(
          () => Trix.required<String>(map, 'id'),
          throwsA(predicate((e) =>
              e is TrixException &&
              e.toString() ==
                  'Field id is not expected type. Found (int) expected (String)')),
        );
      });

      test('valid value', () {
        expect(Trix.required<int>(map, 'id'), 0);
      });
    });

    group('requiredMap', () {
      test('throws if required field is not present', () {
        expect(
          () => Trix.requiredMap<Test>(
              map, 'bogus', (json) => Test.fromJson(json)),
          throwsA(predicate((e) =>
              e is TrixException &&
              e.toString() == 'Field (bogus) is required')),
        );
      });

      test('throws if function result is null', () {
        expect(
          () => Trix.requiredMap<Test>(map, 'test', (json) => null),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Failed to build (Test) from required field (test)'),
          ),
        );
      });

      test('valid value with func', () {
        final test =
            Trix.requiredMap(map, 'test', (json) => Test.fromJson(json));
        expect(test.hello, 'world');
      });
    });

    group('requiredList', () {
      test('throws if required field is not present', () {
        expect(
          () => Trix.requiredList(map, 'bogus',
              (list) => list.map((t) => Test.fromJson(t)).toList()),
          throwsA(predicate((e) =>
              e is TrixException &&
              e.toString() == 'Field (bogus) is required')),
        );
      });

      test('throws if function result is null', () {
        expect(
          () => Trix.requiredList<List<Test>>(map, 'testList', (list) => null),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Failed to build (List<Test>) from required field (testList)'),
          ),
        );
      });

      test('valid value with func', () {
        final testList = Trix.requiredList(
            map, 'testList', (list) => list.map((l) => Test.fromJson(l)));
        expect(testList.first.hello, 'world');
      });
    });

    group('optional', () {
      test('throws if type is not specified', () {
        expect(
          () => Trix.optional(map, 'id'),
          throwsA(
            predicate((e) =>
                e is TrixException &&
                e.toString() ==
                    'Type must be specified for (id), cannot be dynamic'),
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
                    'Field id is not expected type. Found (int) expected (String)'),
          ),
        );
      });

      test('field not present', () {
        expect(Trix.optional<int>(map, 'bogus'), null);
      });

      test('valid value', () {
        expect(Trix.optional<int>(map, 'id'), 0);
      });
    });

    group('optionalMap', () {
      test('null function result', () {
        expect(Trix.optionalMap<Test>(map, 'test', (json) => null), null);
      });

      test('field missing', () {
        expect(Trix.optionalMap<Test>(map, 'bogus', (json) => null), null);
      });

      test('valid value with func', () {
        final value =
            Trix.optionalMap(map, 'test', (json) => Test.fromJson(json));
        expect(value.hello, 'world');
      });
    });

    group('optionalList', () {
      test('null function result', () {
        expect(Trix.optionalList<List<Test>>(map, 'testList', (list) => null),
            null);
      });

      test('field missing', () {
        expect(
            Trix.optionalList<List<Test>>(map, 'bogus', (list) => null), null);
      });

      test('valid value with func', () {
        final testList = Trix.optionalList(
            map, 'testList', (list) => list.map((l) => Test.fromJson(l)));
        expect(testList.first.hello, 'world');
      });
    });
  });
}
