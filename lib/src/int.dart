extension ConvenientlyInt on int {
  void times$(void Function() action) {
    for (var i = 0; i < this; i++) {
      action();
    }
  }

  Future<void> times(Future<void> Function() action) async {
    for (var i = 0; i < this; i++) {
      await action();
    }
  }

  void timesIndex$(void Function(int) action) {
    for (var i = 0; i < this; i++) {
      action(i);
    }
  }

  Future<void> timesIndex(Future<void> Function(int) action) async {
    for (var i = 0; i < this; i++) {
      await action(i);
    }
  }
}
