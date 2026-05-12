extension Records1<A, B> on (A,) {
  T passTo<T>(T Function(A) fun) => fun($1);
}

extension Records2<A, B> on (A, B) {
  T passTo<T>(T Function(A, B) fun) => fun($1, $2);
}

extension Records3<A, B, C> on (A, B, C) {
  T passTo<T>(T Function(A, B, C) fun) => fun($1, $2, $3);
}

extension Records4<A, B, C, D> on (A, B, C, D) {
  T passTo<T>(T Function(A, B, C, D) fun) => fun($1, $2, $3, $4);
}

extension Records5<A, B, C, D, E> on (A, B, C, D, E) {
  T passTo<T>(T Function(A, B, C, D, E) fun) => fun($1, $2, $3, $4, $5);
}

extension Records6<A, B, C, D, E, F> on (A, B, C, D, E, F) {
  T passTo<T>(T Function(A, B, C, D, E, F) fun) => fun($1, $2, $3, $4, $5, $6);
}

extension Records7<A, B, C, D, E, F, G> on (A, B, C, D, E, F, G) {
  T passTo<T>(T Function(A, B, C, D, E, F, G) fun) =>
      fun($1, $2, $3, $4, $5, $6, $7);
}

extension Records8<A, B, C, D, E, F, G, H> on (A, B, C, D, E, F, G, H) {
  T passTo<T>(T Function(A, B, C, D, E, F, G, H) fun) =>
      fun($1, $2, $3, $4, $5, $6, $7, $8);
}
