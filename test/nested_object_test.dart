import 'package:flutter_test/flutter_test.dart';
import 'package:trix/trix.dart';

class A {
  final B b;
  final C c;
  final List<B> listB;
  final List<C> listC;
  final Map<String, B> mapB;
  final Map<String, C> mapC;

  A({this.b, this.c, this.listB, this.listC, this.mapB, this.mapC});

  factory A.fromJson(Map<String, dynamic> json) {
    return A(
      b: Trix.requiredFunc(
        json,
        'b',
        (Map<String, dynamic> json) => B.fromJson(json),
      ),
      c: Trix.optionalFunc(
        json,
        'c',
        (Map<String, dynamic> json) => C.fromJson(json),
      ),
      listB: Trix.optionalFunc(
        json,
        'listB',
        (list) =>
            list.map<B>((Map<String, dynamic> b) => B.fromJson(b)).toList(),
      ),
      listC: Trix.optionalFunc(
        json,
        'listC',
        (list) =>
            list.map<C>((Map<String, dynamic> c) => C.fromJson(c)).toList(),
      ),
      mapB: Trix.optionalFunc(
        json,
        'mapB',
        (map) => map.map<String, B>((String k, Map<String, dynamic> v) =>
            MapEntry<String, B>(k, B.fromJson(v))),
      ),
      mapC: Trix.optionalFunc(
        json,
        'mapC',
        (map) => map.map<String, C>(
            (String k, Map<String, dynamic> v) => MapEntry(k, C.fromJson(v))),
      ),
    );
  }
}

class B {
  final String name;
  final C c;
  final List<C> listC;

  B({this.name, this.c, this.listC});

  factory B.fromJson(Map<String, dynamic> json) {
    return B(
      name: Trix.required(json, 'name'),
      c: Trix.optionalFunc(
          json, 'c', (Map<String, dynamic> c) => C.fromJson(c)),
      listC: Trix.optionalFunc(
          json,
          'listC',
          (list) =>
              list.map<C>((Map<String, dynamic> c) => C.fromJson(c)).toList()),
    );
  }
}

class C {
  final String name;

  C({this.name});

  factory C.fromJson(Map<String, dynamic> json) {
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
      expect(subject.mapB['a'].name, 'b');
      expect(subject.mapB['a'].c.name, 'c');
      expect(subject.mapB['a'].listC[0].name, 'c');
      expect(subject.mapB['a'].listC[1].name, 'b');
      expect(subject.mapC['a'].name, 'c');
    });
  });
}
