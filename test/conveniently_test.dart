import 'dart:io';

import 'package:conveniently/conveniently.dart';
import 'package:test/test.dart';

void main() {
  group(r'timing$', () {
    test('basic', () {
      expect(timing$(() => 11).$2, equals(11));
      expect(timing$(() => '${'foo'.toUpperCase()}-bar').$2, equals('FOO-bar'));
    });
    test('measure duration', () {
      final (duration, value) = timing$(() {
        sleep(const Duration(milliseconds: 25));
        return 'done';
      });
      expect(value, equals('done'));
      expect(duration.inMilliseconds, greaterThan(24));
      expect(duration.inMilliseconds, lessThan(100));
    }, retry: 2);
  });
  group('timing', () {
    test('basic', () async {
      expect((await timing(() async => 11)).$2, equals(11));
      expect((await timing(() async => '${'foo'.toUpperCase()}-bar')).$2,
          equals('FOO-bar'));
    });
    test(r'measure duration', () async {
      final (duration, value) = await timing(() {
        sleep(const Duration(milliseconds: 25));
        return 'done';
      });
      expect(value, equals('done'));
      expect(duration.inMilliseconds, greaterThan(24));
      expect(duration.inMilliseconds, lessThan(100));
    }, retry: 2);
  });

  group('function helpers', () {
    test('vmap', () {
      expect(null.vmap((v) => v), isNull);
      expect(10.vmap((v) => v + 1), equals(11));
      expect(true.vmap((v) => !v), isFalse);
      expect([10, 20].vmap((v) => v.length), equals(2));
    });
    test(r'catching$', () {
      expect(catching$(() => 42), equals(Result.ok(42)));
      expect(
          catching$(() => throw Exception('bad')),
          isA<Fail>().having((e) => e.exception.toString(), 'message',
              equals(Exception('bad').toString())));
    });
    test('catching', () async {
      expect(await catching(() async => 42), equals(Result.ok(42)));
      expect(
          await catching(() async => throw Exception('bad')),
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
    test(r'times$', () {
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

    test(r'timesIndex$', () {
      final list = <int>[];
      0.timesIndex$(list.add);
      expect(list, isEmpty);
      (-1).timesIndex$(list.add);
      expect(list, isEmpty);
      1.timesIndex$(list.add);
      expect(list, equals([0]));
      2.timesIndex$(list.add);
      expect(list, equals([0, 0, 1]));
      list.clear();
      100.timesIndex$(list.add);
      expect(list, equals(List.generate(100, (index) => index)));
    });

    test('times', () async {
      int counter = 0;
      Future<void> inc() async => counter++;
      await 0.times(inc);
      expect(counter, equals(0));
      await (-1).times(inc);
      expect(counter, equals(0));
      await 1.times(inc);
      expect(counter, equals(1));
      await 2.times(inc);
      expect(counter, equals(3));
      await 100.times(inc);
      expect(counter, equals(103));
    });

    test(r'timesIndex', () async {
      final list = <int>[];
      Future<void> add(int i) async => list.add(i);
      await 0.timesIndex(add);
      expect(list, isEmpty);
      await (-1).timesIndex(add);
      expect(list, isEmpty);
      await 1.timesIndex(add);
      expect(list, equals([0]));
      await 2.timesIndex(add);
      expect(list, equals([0, 0, 1]));
      list.clear();
      await 100.timesIndex(add);
      expect(list, equals(List.generate(100, (index) => index)));
    });
  });
}
