import 'package:flutter_test/flutter_test.dart';
import 'package:trix/trix.dart';

class A {
  final B b;
  final C c;
  final List<B> listB;
  final List<C> listC;
  final Map<String, B> mapB;
  final Map<String, C> mapC;

  A({
    required this.b,
    required this.c,
    required this.listB,
    required this.listC,
    required this.mapB,
    required this.mapC,
  });

  factory A.fromJson(Map json) {
    return A(
      b: Trix.requiredMap(
        json,
        'b',
        (json) => B.fromJson(json),
      ),
      c: Trix.requiredMap(
        json,
        'c',
        (json) => C.fromJson(json),
      ),
      listB: Trix.optionalList(
        json,
        'listB',
        (list) => list.map((b) => B.fromJson(b)).toList(),
      )!,
      listC: Trix.optionalList(
        json,
        'listC',
        (list) => list.map((c) => C.fromJson(c)).toList(),
      )!,
      mapB: Trix.optionalMap(
        json,
        'mapB',
        (map) => map.map((k, v) => MapEntry(k as String, B.fromJson(v as Map))),
      )!,
      mapC: Trix.optionalMap(
        json,
        'mapC',
        (map) => map.map((k, v) => MapEntry(k as String, C.fromJson(v as Map))),
      )!,
    );
  }
}

class B {
  final String name;
  final C c;
  final List<C> listC;

  B({
    required this.name,
    required this.c,
    required this.listC,
  });

  factory B.fromJson(Map json) {
    return B(
        name: Trix.required(json, 'name'),
        c: Trix.optionalMap(json, 'c', (c) => C.fromJson(c))!,
        listC: Trix.optionalList(
            json, 'listC', (list) => list.map((c) => C.fromJson(c)).toList())!);
  }
}

class C {
  final String name;

  C({required this.name});

  factory C.fromJson(Map json) {
    return C(
      name: Trix.required(json, 'name'),
    );
  }
}

void main() {
  group('Nested Object', () {
    test('full json', () {
      final json = {
        'b': {
          'name': 'b',
          'c': {'name': 'c'},
          'listC': [
            {'name': 'c'},
            {'name': 'b'}
          ]
        },
        'c': {'name': 'c'},
        'listB': [
          {
            'name': 'b',
            'c': {'name': 'c'},
            'listC': [
              {'name': 'c'},
              {'name': 'b'}
            ]
          }
        ],
        'listC': [
          {'name': 'c'}
        ],
        'mapB': {
          'a': {
            'name': 'b',
            'c': {'name': 'c'},
            'listC': [
              {'name': 'c'},
              {'name': 'b'}
            ]
          }
        },
        'mapC': {
          "a": {'name': 'c'}
        }
      };

      final subject = A.fromJson(json);
      expect(subject.b.name, 'b');
      expect(subject.b.c.name, 'c');
      expect(subject.b.listC[0].name, 'c');
      expect(subject.b.listC[1].name, 'b');
      expect(subject.c.name, 'c');
      expect(subject.listB.first.name, 'b');
      expect(subject.listB.first.c.name, 'c');
      expect(subject.listB.first.listC[0].name, 'c');
      expect(subject.listB.first.listC[1].name, 'b');
      expect(subject.listC.first.name, 'c');
      expect(subject.mapB['a']!.name, 'b');
      expect(subject.mapB['a']!.c.name, 'c');
      expect(subject.mapB['a']!.listC[0].name, 'c');
      expect(subject.mapB['a']!.listC[1].name, 'b');
      expect(subject.mapC['a']!.name, 'c');
    });
  });
}
