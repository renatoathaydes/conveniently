/// Extension functions for functions of arity 1.
extension Function1Extension<A, R> on R Function(A) {
  /// Curry this function using `a` as its first argument.
  /// The returned function behaves the same as this function when it is called
  /// with `a` as an argument.
  ///
  /// ## Example:
  /// ```
  /// String sayHi(String name) => 'Hello $name.';
  ///
  /// final greetJoe = sayHi.curry('Joe');
  /// greetJoe(); // => "Hello Joe."
  /// ```
  ///
  R Function() curry(A a) {
    return () => this(a);
  }
}

/// Extension functions for functions of arity 2.
extension Function2Extension<A, B, R> on R Function(A, B) {
  /// Curry this function using `a` as its first argument.
  /// The returned function behaves the same as this function, except its
  /// first argument will implicitly be `a`.
  ///
  /// ## Example:
  /// ```
  /// String greet(String title, String name) =>
  ///     'Hello $title $name.';
  ///
  /// final greetMrs = greet.curry('Mrs.');
  /// greetMrs('Jones'); // => "Hello Mrs. Jones."
  /// ```
  ///
  R Function(B) curry(A a) {
    return (b) => this(a, b);
  }

  /// Curry this function using `a` and `b` as its first arguments.
  /// The returned function behaves the same as this function, except its
  /// first arguments will implicitly be `a` and `b`.
  ///
  /// ## Example:
  /// ```
  /// String greet(String title, String name) =>
  ///     'Hello $title $name.';
  ///
  /// final greetMrsJones = greet.curry2('Mrs.', 'Jones');
  /// greetMrsJones(); // => "Hello Mrs. Jones."
  /// ```
  ///
  R Function() curry2(A a, B b) {
    return () => this(a, b);
  }

  /// Rotate the arguments of this function.
  ///
  /// * Original function: `R Function example(A, B);`
  /// * Returned function: `R Function example(B, A);`
  R Function(B, A) rot() {
    return (b, a) => this(a, b);
  }
}

/// Extension functions for functions of arity 3.
extension Function3Extension<A, B, C, R> on R Function(A, B, C) {
  /// Curry this function using `a` as its first argument.
  /// The returned function behaves the same as this function, except its
  /// first argument will implicitly be `a`.
  ///
  /// ## Example:
  /// ```
  /// listFiles(String workingDir, String path, int limit);
  ///
  /// final listFromHome = listFiles.curry(homeDir());
  /// listFromHome('.app', 3); // lists up to 3 files in ~/.app/
  /// ```
  ///
  R Function(B, C) curry(A a) {
    return (b, c) => this(a, b, c);
  }

  /// Curry this function using `a` and `b` as its first two arguments.
  /// The returned function behaves the same as this function, except its
  /// first arguments will implicitly be `a` and `b`.
  ///
  /// ## Example:
  /// ```
  /// listFiles(String workingDir, String path, int limit);
  ///
  /// final listLocalBin = listFiles.curry2(homeDir(), '.local/bin');
  /// listLocalBin(3); // lists up to 3 files in ~/.local/bin
  /// ```
  ///
  R Function(C) curry2(A a, B b) {
    return (c) => this(a, b, c);
  }

  /// Curry this function using `a`, `b` and `c` as its arguments.
  /// The returned function behaves the same as this function, except its
  /// arguments will implicitly be `a`, `b` and `c`.
  ///
  /// ## Example:
  /// ```
  /// listFiles(String workingDir, String path, int limit);
  ///
  /// final listLocalBin1 = listFiles.curry3(homeDir(), '.local/bin', 1);
  /// listLocalBin1(); // lists up to one file in ~/.local/bin
  /// ```
  ///
  R Function() curry3(A a, B b, C c) {
    return () => this(a, b, c);
  }

  /// Rotate the arguments of this function to the right.
  ///
  /// * Original function: `R Function example(A, B, C);`
  /// * Returned function: `R Function example(C, A, B);`
  R Function(C, A, B) rot() {
    return (c, a, b) => this(a, b, c);
  }

  /// Rotate the arguments of this function to the left.
  ///
  /// * Original function: `R Function example(A, B, C);`
  /// * Returned function: `R Function example(B, C, A);`
  R Function(B, C, A) rotLeft() {
    return (b, c, a) => this(a, b, c);
  }
}
