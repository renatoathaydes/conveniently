import 'package:conveniently/conveniently.dart';

extension ConvenientlyNullable<V> on V? {
  /// Map over a nullable Dart value.
  ///
  /// If this is null, a default value is computed by calling the given
  /// [defaultValue] function, and that is returned.
  ///
  /// This function may be used to capture a value which may otherwise require
  /// using a final local variable for keeping flow analysis working,
  /// such as fields (even final fields).
  ///
  /// It can also be used to write transformation pipelines, for example:
  ///
  /// ```dart
  ///   return computeSomeValue()
  ///       .vmapOr(checkValid, () => 'default') // String checkValid(String s)
  ///       .vmap(sanitize) // String sanitize(String s)
  ///       .apply(store) // Future<Anything> store(String s)
  ///       .then(removeSensitiveData); // String removeSensitiveData(String s)
  /// ```
  ///
  /// This example also uses the Conveniently function [apply]
  /// (to use a function that does not return a value in the pipeline)
  /// and [Future]'s `then` (like `vmap`, but for Futures).
  R vmapOr<R>(R Function(V) map, R Function() defaultValue) {
    final value = this;
    return value == null ? defaultValue() : map(value);
  }

  /// Check that this value is not null.
  ///
  /// If this value is null or `accept` returns `false` when called with the
  /// non-null value, then the given [throwable] function is called, which
  /// may either throw an Exception itself, or return a value that will be
  /// thrown.
  ///
  /// By default, `Exception('unexpected value: $value')` is thrown.
  V orThrow(
      [Object Function()? throwable, bool Function(V) accept = alwaysTrue]) {
    final value = this;
    if (value == null || !accept(value)) {
      throw throwable?.call() ?? Exception('unexpected value: $value');
    }
    return value;
  }
}
