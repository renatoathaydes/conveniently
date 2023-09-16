extension ConvenientlyAny<V> on V {
  /// Map over a basic Dart value.
  ///
  /// This function may be used to capture a value which may otherwise require
  /// using a final local variable for keeping flow analysis working,
  /// such as fields (even final fields).
  ///
  /// It can also be used to write transformation pipelines, for example:
  ///
  /// ```dart
  ///   return computeSomeValue()
  ///       ?.vmap(checkValid) // String checkValid(String s)
  ///        .vmap(sanitize) // String sanitize(String s)
  ///        .apply(store) // Future<Anything> store(String s)
  ///        .then(removeSensitiveData); // String removeSensitiveData(String s)
  /// ```
  ///
  /// This example also uses the Conveniently function [apply]
  /// (to use a function that does not return a value in the pipeline)
  /// and [Future]'s `then` (like `vmap`, but for Futures).
  ///
  /// See also [vmapOr].
  R vmap<R>(R Function(V) map) => map(this);

  /// Apply a function to a Dart value synchronously.
  ///
  /// This function is normally used in transformation pipelines.
  ///
  /// See [vmap] for an example of how to use this function.
  V apply$(void Function(V) action) {
    action(this);
    return this;
  }

  /// Apply a function to a Dart value asynchronously.
  ///
  /// This function is normally used in transformation pipelines.
  ///
  /// See [vmap] for an example of how to use this function.
  Future<V> apply(Future<void> Function(V) action) async {
    await action(this);
    return this;
  }
}
