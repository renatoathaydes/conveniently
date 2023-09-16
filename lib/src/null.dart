extension ConvenientlyNullable<V> on V? {
  R vmapOr<R>(R Function(V) map, R Function() defaultValue) {
    final value = this;
    return value == null ? defaultValue() : map(value);
  }

  V orThrow([Object Function()? throwable]) {
    final value = this;
    if (value == null) {
      throw throwable?.call() ?? Exception();
    }
    return value;
  }
}
