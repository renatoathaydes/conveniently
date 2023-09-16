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

  /// Map over this [Result].
  ///
  /// If this is an [Ok] result, then the `success` mapper function is
  /// called with the successful value, otherwise the `failure`
  /// function is called with the failure (by default, the same failure
  /// is returned).
  ///
  /// If either the [success] or [failure] functions throw, a [Fail]
  /// Result is returned with a [MappingFailureException] failure.
  Result<T> map<T>(T Function(V) success,
      {Exception Function(Exception) failure = _identityException});

  /// Map over this [Result].
  ///
  /// If this is an [Ok] result, then the `success` mapper function is
  /// called with the successful value, otherwise the `failure`
  /// function is called with the failure (by default, the same failure
  /// is returned).
  ///
  /// If either the [success] or [failure] functions throw, a [Fail]
  /// Result is returned with a [MappingFailureException] failure.
  Result<T> flatMap<T>(Result<T> Function(V) success,
      {Exception Function(Exception) failure = _identityException});
}

Exception _identityException(Exception e) => e;

/// Exception that gets wrapped into a [Fail] result in case a [Result]
/// mapping operation throws.
final class MappingFailureException<V> implements Exception {
  /// The cause of this [MappingFailureException].
  final Exception mappingFailure;

  /// The original [Result] that was being mapped.
  final Result<V> originalResult;

  /// Create an instance of [MappingFailureException].
  const MappingFailureException(this.mappingFailure, this.originalResult);

  @override
  String toString() {
    return 'MappingFailureException{'
        'originalResult: $originalResult, '
        'mappingFailure: $mappingFailure}';
  }
}

/// Success case of [Result].
final class Ok<V> extends Result<V> {
  /// The successful value.
  final V value;

  /// Returns false.
  @override
  get isError => false;

  /// Returns null.
  @override
  get failureOrNull => null;

  /// Returns the successful value.
  @override
  V get successOrNull => value;

  /// Const constructor.
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

  @override
  Result<T> map<T>(T Function(V) success,
      {Exception Function(Exception) failure = _identityException}) {
    try {
      return Ok(success(value));
    } on Exception catch (e) {
      return Fail(MappingFailureException(e, this));
    }
  }

  @override
  Result<T> flatMap<T>(Result<T> Function(V) success,
      {Exception Function(Exception) failure = _identityException}) {
    try {
      return success(value);
    } on Exception catch (e) {
      return Fail(MappingFailureException(e, this));
    }
  }
}

/// Failure case of [Result].
final class Fail<V> extends Result<V> {
  /// The exception that caused this failure.
  final Exception exception;

  /// Returns true.
  @override
  get isError => true;

  /// Returns the [exception].
  @override
  Exception get failureOrNull => exception;

  /// Returns `null`.
  @override
  get successOrNull => null;

  /// Const constructor.
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

  @override
  Result<T> map<T>(T Function(V) success,
      {Exception Function(Exception) failure = _identityException}) {
    try {
      return Fail(failure(exception));
    } on Exception catch (e) {
      return Fail(MappingFailureException(e, this));
    }
  }

  @override
  Result<T> flatMap<T>(Result<T> Function(V) success,
      {Exception Function(Exception) failure = _identityException}) {
    try {
      return Fail(failure(exception));
    } on Exception catch (e) {
      return Fail(MappingFailureException(e, this));
    }
  }
}
