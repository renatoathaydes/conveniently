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

      result = Result.fail(const FormatException());
      value = switch (result) {
        Ok(value: var v) => v,
        Fail(exception: var e) => e,
      };
      expect(value, isFormatException);
    });
    test('map success', () {
      Result<String> result;
      result = Result.ok('yes');
      expect(result.map((s) => 'OK=$s'), equals(Ok('OK=yes')));
    });
    test('map failure (default)', () {
      Result<String> result;
      result = Result.fail(const FormatException());
      expect(result.map((s) => 'OK=$s'), equals(const Fail(FormatException())));
    });
    test('map failure (custom failure mapper)', () {
      Result<String> result;
      result = Result.fail(const FormatException());
      expectFailure(result.map((s) => 'OK=$s', failure: (f) => Exception(f)),
          Exception(const FormatException()));
    });
    test('map success (mapping failure)', () {
      Result<String> result;
      result = Result.ok('yes');
      expectFailure(result.map((s) {
        throw Exception('not mapping');
      }), MappingFailureException(Exception('not mapping'), result));
    });
    test('map failure (custom failure mapper failing)', () {
      Result<String> result;
      result = Result.fail(const FormatException());
      expectFailure(
          result.map((s) => 'OK=$s', failure: (f) => throw Exception(f)),
          MappingFailureException(Exception(const FormatException()), result));
    });
    test('flatMap success', () {
      Result<String> result;
      result = Result.ok('yes');
      expect(result.flatMap((s) => Ok('OK=$s')), equals(Ok('OK=yes')));
    });
    test('flatMap success to failure', () {
      Result<String> result;
      result = Result.ok('yes');
      expectFailure(
          result.flatMap((s) => Fail(Exception(s))), Exception('yes'));
    });
    test('flatMap failure (default)', () {
      Result<String> result;
      result = Result.fail(const FormatException());
      expect(result.flatMap(Ok.new), equals(const Fail(FormatException())));
    });
    test('flatMap failure (custom failure mapper)', () {
      Result<String> result;
      result = Result.fail(const FormatException());
      expectFailure(result.flatMap(Ok.new, failure: (f) => Exception(f)),
          Exception(const FormatException()));
    });
    test('flatMap success (mapping failure)', () {
      Result<String> result;
      result = Result.ok('yes');
      expectFailure(result.flatMap((s) {
        throw Exception('not mapping');
      }), MappingFailureException(Exception('not mapping'), result));
    });
    test('flatMap failure (custom failure mapper failing)', () {
      Result<String> result;
      result = Result.fail(const FormatException());
      expectFailure(result.flatMap(Ok.new, failure: (f) => throw Exception(f)),
          MappingFailureException(Exception(const FormatException()), result));
    });
  });
}

void expectFailure(Result<Object?> result, Exception exception) {
  var _ = switch (result) {
    Ok(value: var v) => fail('Expected a failure but got Success: $v'),
    Fail(exception: var f) =>
      expect(f.toString(), equals(exception.toString())),
  };
}
