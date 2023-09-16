sealed class Result<V> {
  abstract final bool isError;

  abstract final V? successOrNull;

  abstract final Exception? failureOrNull;

  const Result();

  factory Result.ok(V value) => Ok(value);

  factory Result.fail(Exception e) => Fail(e);
}

final class Ok<V> extends Result<V> {
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

final class Fail<V> extends Result<V> {
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
