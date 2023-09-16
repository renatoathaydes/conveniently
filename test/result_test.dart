import 'package:conveniently/conveniently.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Result', () {
    test('ok', () {
      Result.ok(10)
        ..vmap((v) => expect(v.isError, isFalse))
        ..vmap((v) => expect(v.failureOrNull, isNull))
        ..vmap((v) => expect(v.successOrNull, equals(10)));
    });
    test('failure', () {
      Result.fail(Exception('a failure'))
        ..vmap((v) => expect(v.isError, isTrue))
        ..vmap((v) => expect(v.failureOrNull?.toString(),
            equals(Exception('a failure').toString())))
        ..vmap((v) => expect(v.successOrNull, isNull));
    });
    test('pattern matching', () {
      Result<String> result;
      result = Result.ok('yes');
      Object value =
          switch (result) { Ok(value: var v) => v, Fail() => 'error' };
      expect(value, equals('yes'));

      result = Result.fail(FormatException());
      value = switch (result) {
        Ok(value: var v) => v,
        Fail(exception: var e) => e,
      };
      expect(value, isFormatException);
    });
  });
}
