/// Result of a computation that may fail.
///
/// [Result] has two constructors, [Result.ok] and [Result.fail].
/// These may be used to create [Result] instances directly, or the
/// [catching] and [catching$] functions may be used for convenience.
///
/// To check which case a [Result] represents, use pattern matching:
///
/// ```dart
/// final result = await catching(() { ... });
/// return switch(result) {
///   Ok(value: var v) => 'Success: $v',
///   Fail(exception: var e) => 'Failure: $e',
/// };
/// ```
///
/// You can also check its type directly (e.g. `result is Ok`) or use the
/// getters [isError], [successOrNull] and [failureOrNull].
sealed class Result<V> {
  /// Returns `true` if this is a [Fail], false otherwise.
  abstract final bool isError;

  /// The successful value if this is [Ok], null otherwise.
  abstract final V? successOrNull;

  /// The failure Exception if this is [Fail], null otherwise.
  abstract final Exception? failureOrNull;

  /// Const constructor.
  const Result();

  /// Create an [Ok] instance.
  factory Result.ok(V value) => Ok(value);

  /// Create a [Fail] instance.
  factory Result.fail(Exception e) => Fail(e);
}

/// Success case of [Result].
final class Ok<V> extends Result<V> {
  /// The successful value.
  final V value;

  @override
  get isError => false;

  @override
  get failureOrNull => null;

  @override
  get successOrNull => value;

  const Ok(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Ok && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'Ok{value: $value}';
  }
}

/// Failure case of [Result].
final class Fail<V> extends Result<V> {
  /// The exception that caused this failure.
  final Exception exception;

  @override
  get isError => true;

  @override
  get failureOrNull => exception;

  @override
  get successOrNull => null;

  const Fail(this.exception);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Fail && exception == other.exception;

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() {
    return 'Fail{exception: $exception}';
  }
}
