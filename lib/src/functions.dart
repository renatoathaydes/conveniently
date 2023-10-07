import 'dart:async';

import 'result.dart';

/// Run the given synchronous action, returning a [Duration] representing
/// how long it took to complete, and the value returned by it.
(Duration, V) timing$<V>(V Function() action) {
  final stopWatch = Stopwatch()..start();
  final result = action();
  return (stopWatch.elapsed, result);
}

/// Run the given asynchronous action, returning a [Duration] representing
/// how long it took to complete, and the value returned by it.
Future<(Duration, V)> timing<V>(FutureOr<V> Function() action) async {
  final stopWatch = Stopwatch()..start();
  final result = await action();
  return (stopWatch.elapsed, result);
}

/// Run the given synchronous action, capturing any Exception it may
/// throw in a [Result] object.
Result<V> catching$<V>(V Function() action) {
  try {
    return Result.ok(action());
  } on Exception catch (e) {
    return Result.fail(e);
  } catch (e) {
    return Result.fail(Exception(e));
  }
}

/// Run the given asynchronous action, capturing any Exception it may
/// throw in a [Result] object.
Future<Result<V>> catching<V>(Future<V> Function() action) async {
  try {
    return Result.ok(await action());
  } on Exception catch (e) {
    return Result.fail(e);
  } catch (e) {
    return Result.fail(Exception(e));
  }
}

/// Predicate function that always returns true.
///
/// This is meant to be used mostly as default value for function arguments.
bool alwaysTrue(Object? anything) => true;

/// Predicate function that always returns false.
///
/// This is meant to be used mostly as default value for function arguments.
bool alwaysFalse(Object? anything) => false;
