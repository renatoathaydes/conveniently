extension ConvenientlyInt on int {
  /// Repeat the given synchronous action this number of times.
  ///
  /// If this is zero or a negative value, the action is never run.
  void times$(void Function() action) {
    for (var i = 0; i < this; i++) {
      action();
    }
  }

  /// Repeat the given asynchronous action this number of times.
  ///
  /// If this is zero or a negative value, the action is never run.
  ///
  /// The [waitIterations] parameter indicates whether each iteration must
  /// wait for the previous one to complete before starting. If `false`,
  /// all iterations are started immediately.
  ///
  /// The returned [Future] completes when all iterations complete.
  Future<void> times(Future<void> Function() action,
      {bool waitIterations = true}) async {
    if (waitIterations) {
      for (var i = 0; i < this; i++) {
        await action();
      }
    } else {
      return await Future.wait(Iterable.generate(this, (i) => action()),
              eagerError: true)
          .then((_) => null);
    }
  }

  /// Repeat the given synchronous action this number of times, passing
  /// the iteration index to it.
  ///
  /// If this is zero or a negative value, the action is never run.
  void timesIndex$(void Function(int) action) {
    for (var i = 0; i < this; i++) {
      action(i);
    }
  }

  /// Repeat the given asynchronous action this number of times, passing
  /// the iteration index to it.
  ///
  /// If this is zero or a negative value, the action is never run.
  ///
  /// The [waitIterations] parameter indicates whether each iteration must
  /// wait for the previous one to complete before starting. If `false`,
  /// all iterations are started immediately.
  ///
  /// The returned [Future] completes when all iterations complete.
  Future<void> timesIndex(Future<void> Function(int) action,
      {bool waitIterations = true}) async {
    if (waitIterations) {
      for (var i = 0; i < this; i++) {
        await action(i);
      }
    } else {
      return await Future.wait(Iterable.generate(this, action),
              eagerError: true)
          .then((_) => null);
    }
  }
}
