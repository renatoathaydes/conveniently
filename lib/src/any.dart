extension ConvenientlyAny<V> on V {
  R vmap<R>(R Function(V) map) => map(this);
}
