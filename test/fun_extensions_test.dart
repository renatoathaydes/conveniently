import 'package:conveniently/conveniently.dart';
import 'package:test/test.dart';

void main() {
  // arity-1
  String upper(String s) => s.toUpperCase();

  // arity-2
  String subStr(String s, int start) => s.substring(start);

  // arity-3
  String replaceX(String s, int start, int end) =>
      s.replaceRange(start, end, 'X');

  // from example docs
  String homeDir() => '';

  String sayHi(String name) => 'Hello $name.';

  String greet(String title, String name) => 'Hello $title $name.';

  List<String> listFiles(String workingDir, String path, int limit) {
    const files = ['f1', 'f2', 'f3', 'f4'];
    return files.sublist(0, limit);
  }

  group('Function1Extension', () {
    test('curry', () {
      expect(upper.curry('foo')(), equals('FOO'));

      // from example docs
      final greetJoe = sayHi.curry('Joe');
      expect(greetJoe(), equals('Hello Joe.'));
    });
  });

  group('Function2Extension', () {
    test('curry', () {
      expect(subStr.curry('bar')(1), equals('ar'));

      // from example docs
      final greetMrs = greet.curry('Mrs.');
      expect(greetMrs('Jones'), equals('Hello Mrs. Jones.'));
    });

    test('curry2', () {
      expect(subStr.curry2('bar', 1)(), equals('ar'));

      // from example docs
      final greetMrsJones = greet.curry2('Mrs.', 'Jones');
      expect(greetMrsJones(), equals('Hello Mrs. Jones.'));
    });

    test('rot', () {
      expect(subStr.rot()(2, 'zort'), equals('rt'));
    });
  });

  group('Function3Extension', () {
    test('curry', () {
      expect(replaceX.curry('hello')(2, 4), equals('heXo'));

      // from example docs
      final listFromHome = listFiles.curry(homeDir());
      expect(listFromHome('.app', 3), equals(['f1', 'f2', 'f3']));
    });

    test('curry2', () {
      expect(replaceX.curry2('hello', 2)(4), equals('heXo'));

      // from example docs
      final listLocalBin = listFiles.curry2(homeDir(), '.local/bin');
      expect(listLocalBin(3), equals(['f1', 'f2', 'f3']));
    });

    test('curry3', () {
      expect(replaceX.curry3('hello', 2, 4)(), equals('heXo'));

      // from example docs
      final listLocalBin1 = listFiles.curry3(homeDir(), '.local/bin', 1);
      expect(listLocalBin1(), equals(['f1']));
    });

    test('rot', () {
      expect(replaceX.rot()(4, 'hello', 2), equals('heXo'));
    });

    test('rotLeft', () {
      expect(replaceX.rotLeft()(2, 4, 'hello'), equals('heXo'));
    });
  });
}
