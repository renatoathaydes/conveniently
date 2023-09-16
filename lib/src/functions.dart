import 'dart:async';

import 'result.dart';

(Duration, V) timing$<V>(V Function() action) {
  final stopWatch = Stopwatch()..start();
  final result = action();
  return (stopWatch.elapsed, result);
}

Future<(Duration, V)> timing<V>(FutureOr<V> Function() action) async {
  final stopWatch = Stopwatch()..start();
  final result = await action();
  return (stopWatch.elapsed, result);
}

Result<V> catching$<V>(V Function() action) {
  try {
    return Result.ok(action());
  } on Exception catch (e) {
    return Result.fail(e);
  } catch (e) {
    return Result.fail(Exception(e));
  }
}

Future<Result<V>> catching<V>(Future<V> Function() action) async {
  try {
    return Result.ok(await action());
  } on Exception catch (e) {
    return Result.fail(e);
  } catch (e) {
    return Result.fail(Exception(e));
  }
}
