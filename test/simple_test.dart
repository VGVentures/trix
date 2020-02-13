import 'package:flutter_test/flutter_test.dart';
import 'package:trix/trix.dart';
import 'package:trix/trix_exception.dart';

class Simple {
  final int requiredInt;
  final int optionalInt;
  final String requiredString;
  final String optionalString;

  Simple(
      {this.requiredInt,
      this.optionalInt,
      this.requiredString,
      this.optionalString});

  factory Simple.fromJson(Map<String, dynamic> json) {
    return Simple(
        requiredInt: Trix.required(json, 'requiredInt'),
        optionalInt: Trix.optional(json, 'optionalInt'),
        requiredString: Trix.required(json, 'requiredString'),
        optionalString: Trix.optional(json, 'optionalString'));
  }
}

void main() {
  group('Simple', () {
    test('all properties', () {
      final json = {
        'requiredInt': 0,
        'optionalInt': 1,
        'requiredString': 'a',
        'optionalString': 'b'
      };

      final subject = Simple.fromJson(json);
      expect(subject.requiredInt, 0);
      expect(subject.optionalInt, 1);
      expect(subject.requiredString, 'a');
      expect(subject.optionalString, 'b');
    });

    test('required properties', () {
      final json = {
        'requiredInt': 0,
        'requiredString': 'a',
      };
      final subject = Simple.fromJson(json);
      expect(subject.requiredInt, 0);
      expect(subject.optionalInt, null);
      expect(subject.requiredString, 'a');
      expect(subject.optionalString, null);
    });

    test('missing required int', () {
      final json = {
        'requiredString': 'a',
      };
      expect(
        () => Simple.fromJson(json),
        throwsA(
          predicate((e) =>
              e is TrixException &&
              e.message == 'Field (requiredInt) is required'),
        ),
      );
    });

    test('missing required string', () {
      final json = {
        'requiredInt': 0,
      };
      expect(
        () => Simple.fromJson(json),
        throwsA(
          predicate((e) =>
              e is TrixException &&
              e.message == 'Field (requiredString) is required'),
        ),
      );
    });
  });
}
