import 'dart:io';

import 'package:conveniently/conveniently.dart';
import 'package:test/test.dart';

void main() {
  group('timing', () {
    test('basic', () {
      expect(timing$(() => 11).$2, equals(11));
      expect(timing$(() => '${'foo'.toUpperCase()}-bar').$2, equals('FOO-bar'));
    });
    test('timer', () {
      final (duration, value) = timing$(() {
        sleep(const Duration(milliseconds: 25));
        return 'done';
      });
      expect(value, equals('done'));
      expect(duration.inMilliseconds, greaterThan(24));
      expect(duration.inMilliseconds, lessThan(100));
    });
  });

  group('function helpers', () {
    test('vmap', () {
      expect(null.vmap((v) => v), isNull);
      expect(10.vmap((v) => v + 1), equals(11));
      expect(true.vmap((v) => !v), isFalse);
      expect([10, 20].vmap((v) => v.length), equals(2));
    });
    test('catching', () {
      expect(catching$(() => 42), equals(Result.ok(42)));
      expect(
          catching$(() => throw Exception('bad')),
          isA<Fail>().having((e) => e.exception.toString(), 'message',
              equals(Exception('bad').toString())));
    });
  });

  group('nullable extensions', () {
    test('vmapOr', () {
      int? value = 10;
      expect(10.vmapOr((v) => v + 1, () => -1), equals(11));
      value = null;
      expect(value.vmapOr((v) => v + 1, () => -1), equals(-1));
    });
    test('orThrow', () {
      Object? object;
      object = 10;
      expect(object.orThrow(() => 'error'), equals(10));
      object = 'foo';
      expect(object.orThrow(() => 'error'), equals('foo'));
      object = null;
      expect(() => object.orThrow(() => 'error'), throwsA('error'));
      expect(() => object.orThrow(), throwsA(isA<Exception>()));
    });
  });

  group('int extensions', () {
    test('times', () {
      int counter = 0;
      void inc() => counter++;
      0.times$(inc);
      expect(counter, equals(0));
      (-1).times$(inc);
      expect(counter, equals(0));
      1.times$(inc);
      expect(counter, equals(1));
      2.times$(inc);
      expect(counter, equals(3));
      100.times$(inc);
      expect(counter, equals(103));
    });
  });
}
