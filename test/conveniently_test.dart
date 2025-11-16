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
      expect(duration.inMilliseconds, lessThan(120));
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
      expect(duration.inMilliseconds, lessThan(120));
    }, retry: 2);
  });

  group('function helpers', () {
    test('identity', () {
      expect(identity('hi'), equals('hi'));
      expect({1, 2}.map(identity).toList(), equals([1, 2]));
    });

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
    test(r'apply$', () {
      final list = <int>[];
      final result = list.apply$((l) => l.add(1));
      expect(list, equals([1]));
      expect(result, same(list));
    });
    test('apply', () async {
      final list = <int>[];
      final result = await list.apply((l) async => l
        ..add(1)
        ..add(2));
      expect(list, equals([1, 2]));
      expect(result, same(list));
    });
    test('alwaysTrue', () {
      expect([1, 2, 3].where(alwaysTrue).toList(), equals([1, 2, 3]));
    });
    test('alwaysFalse', () {
      expect([1, 2, 3].where(alwaysFalse).toList(), isEmpty);
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

    test('times (not waiting for iterations)', () async {
      final times = <int>[];
      final start = DateTime.now().millisecondsSinceEpoch;
      Future<void> go() async {
        await Future.delayed(const Duration(milliseconds: 25));
        times.add(DateTime.now().millisecondsSinceEpoch);
      }

      await 5.times(go, waitIterations: false);
      expect(times, hasLength(5));
      expect(times, everyElement(greaterThan(start + 24)));
      expect(times, everyElement(lessThan(start + 100)));
    }, retry: 2);

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

    test('timesIndex (not waiting for iterations)', () async {
      final timesAndIndexes = <(int, int)>[];
      final start = DateTime.now().millisecondsSinceEpoch;
      Future<void> go(i) async {
        await Future.delayed(const Duration(milliseconds: 25));
        timesAndIndexes.add((i + 1, DateTime.now().millisecondsSinceEpoch));
      }

      await 5.timesIndex(go, waitIterations: false);

      final times = timesAndIndexes.map((i) => i.$2).toList();
      expect(times, hasLength(5));
      expect(times, everyElement(greaterThan(start + 24)));
      expect(times, everyElement(lessThan(start + 100)));

      final indexes = timesAndIndexes.map((i) => i.$1).toSet();
      expect(indexes, hasLength(5));
      expect(indexes, everyElement(greaterThan(0)));
      expect(indexes, everyElement(lessThan(6)));
    }, retry: 2);
  });

  group('predicates', () {
    test(r'not$', () {
      const set = {'a', 'b'};
      expect([].where(set.contains.not$).toList(), equals([]));
      expect(['a', 'b'].where(set.contains.not$).toList(), equals([]));
      expect(['a', 'b', 'c'].where(set.contains.not$).toList(), equals(['c']));
      expect(['d', 'c'].where(set.contains.not$).toList(), equals(['d', 'c']));
    });
    test('not', () async {
      const set = {'a', 'b'};
      Future<bool> containsAsync(String obj) async => set.contains(obj);
      final Future<bool> Function(String) notContainsAsync = containsAsync.not;

      expect(await notContainsAsync('a'), isFalse);
      expect(await notContainsAsync('d'), isTrue);
    });
  });
}
