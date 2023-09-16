extension ConvenientlyPredicate<T> on bool Function(T) {
  /// Negate a predicate function.
  ///
  /// If the original function would return `true`, then the returned
  /// function returns `false`, and vice-versa.
  bool Function(T) get not$ => (v) => !this(v);
}

extension ConvenientlyAsyncPredicate<T> on Future<bool> Function(T) {
  /// Negate a predicate function.
  ///
  /// If the original function would return `true`, then the returned
  /// function returns `false`, and vice-versa.
  Future<bool> Function(T) get not => (v) async => !(await this(v));
}
