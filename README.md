<!--                  DO NOT EDIT                        -->
<!-- This file is auto-generated from README.template.md -->
# Conveniently.

Write Dart code more conveniently.

This is a tiny package that offers some very convenient utilities that you may use quite often
once you know they exist.

![conveniently](https://github.com/renatoathaydes/conveniently/workflows/conveniently-build/badge.svg)
[![pub package](https://img.shields.io/pub/v/conveniently.svg)](https://pub.dev/packages/conveniently)

> Many of the _conveniently_ functions come in both synchronous and async variants.
> In such cases, the synchronous
> function's name appends `$` to the async function's name.
> The Dart stdlib normally adds the `Sync` suffix in such cases, but I thought `$` would be
> a better suffix as it's shorter and I believe programmers can quickly internalize that as
> meaning `Sync` in their heads.

## Types

### `Result<V>`

The `Result` type is used to represent the result of a computation. It may be either successful
(an instance of `Ok`) or a failure (of type `Fail`).

It helps enforce error checking as the caller of a function returning `Result` is forced to
_inspect_ the returned value for errors, as opposed to with `Exception`s.

You normally obtain a `Result` by calling `catching` or `catching$` (see more examples at the end of this page).

```dart
final result = catching$(() {
  // run computation that may throw
});

// pattern match to handle the result
Object value = switch (result) {
  Ok(value: var v) => v,
  Fail() => 'error'
};
```

You can also create a `Result` by invoking its factory methods:

```dart
Result<String> result;
result = Result.ok('yes');
result = Result.fail(FormatException());
```

To change the type `V` of a `Result<V>`, use its `map` or `flatMap` functions.

> If the mapper function throws, `map` and `flatMap` return a `Fail` Result with a
> `MappingFailureException` within it.

Example:

```dart

Result<int> result = Result.ok('yes').map((s) => s.length);
```

## Top-level functions

* `timing`      - time a computation (asynchronous).
* `timing$`     - time a computation (synchronous).
* `catching`    - enforce error handling (asynchronous).
* `catching$`   - enforce error handling (synchronous).
* `alwaysTrue`  - predicate function that always returns `true`.
* `alwaysFalse` - predicate function that always returns `false`.

The predicate functions above are very useful as default function argument values, given that Dart
does not allow declaring a lambda for a default argument value.

The `catching` functions return a `Result<T>` and never throw, which enforces that callers handle errors.

## Extension functions

### on `<T>` (any type, including nullable types)

* `vmap`    - map over any value.
* `apply`   - call a given function taking the receiver, return the receiver (asynchronous).
* `apply$`  - call a given function taking the receiver, return the receiver (synchronous).

This is particularly convenient to _capture_ fields, e.g. in cases like this:

```dart
class Person {
  final String? name;
  const Person(this.name);

  // DOES NOT COMPILE!
  // @override toString() {
    // if (name == null) return '<No name>';
    // Even though 'name' is final, a subtype could turn it into a mutable getter.
    // return name.capitalize();
  // }
  
  @override toString() {
    // using `vmap` and `apply`ing a side-effecting function 
    return name?.vmap((n) => n.capitilize()).apply$(print) ?? '<No name>';
  }
}
```

### on `<T?>` (any nullable type)

* `vmapOr`  - map over the value if non-null, or provide a default value.
* `orThrow` - get the value if non-null, or throw an error otherwise.

`orThrow` exists due to Dart not allowing this:

```dart
Object? nullableValue = null;

// In Dart, this is ok:
final someValue = nullableValue ?? 'yes!';

// MISSING DART FUNCTIONALITY - DOES NOT COMPILE
final value = nullableValue ?? throw Exception('a good error message here');

// the '!' operator also does it, but does not give a good error for end users.
final nonNullValue = nullableValue!;

// orThrow to the rescue
final aValue = nullableValue.orThrow(() => ArgumentError('missing something', 'value'));
```

### on `int`

* `times`         - run some action N times, asynchronously.
* `times$`        - run some action N times, synchronously.
* `timesIndex`    - run some action N times taking an iteration index, asynchronously.
* `timesIndex$`   - run some action N times taking an iteration index, synchronously.

The async `times` functions accept an optional `waitIterations` parameter which determines whether
each iteration should wait for the previous one to complete before starting.
By default, `waitIterations` is `true`. Setting it to `false` causes all iterations to start
immediately.

### on `bool Function(T)` and `Future<bool> Function(T)` (predicates)

* `not`   - negate an asynchronous predicate.
* `not$`  - negate a synchronous predicate.

### `<A, R> on R Function(A)`

* `curry` - curries a function taking one argument, returning a no-args function.

### `<A, B, R> on R Function(A, B)`

* `curry` - curries a function taking two arguments, returning a 1-arg function.
* `curry2` - curries a function taking two arguments, returning a no-args function.
* `rot` - rotates the order of the arguments of the function (`(A, B)` => `(B, A)`).

### `<A, B, C, R> on R Function(A, B, C)`

* `curry` - curries a function taking three arguments, returning a 2-arg function.
* `curry2` - curries a function taking three arguments, returning a 1-arg function.
* `curry3` - curries a function taking three arguments, returning a no-args function.
* `rot` - rotates the order of the arguments of the function to the right (`(A, B, C)` => `(C, A, B)`).
* `rotLeft` - rotates the order of the arguments of the function to the left (`(A, B, C)` => `(B, C, A)`).

## Examples

```dart
import 'package:conveniently/conveniently.dart';

/// Conveniently examples.
///
/// Functions whose name ends with '$' indicate they are "synchronous",
/// and dropping the '$' gives the corresponding async function's name.
void main() {
  // do something N times
  3.times$(() => print('Conveniently'));

  // with an index
  2.timesIndex$((i) => print('Conveniently $i'));

  // map over any value
  print(10.vmap((i) => i + 1)); // prints 11

  // nullable helpers make it more like Optional
  Object? nullable;
  nullable = 'foo';
  print(nullable.vmapOr((v) => 'v = $v', () => 'none')); // prints 'v = foo'
  print(nullable.orThrow(ArgumentError.new)); // prints 'foo'
  nullable = null;
  print(nullable.vmapOr((v) => 'v = $v', () => 'none')); // prints 'none'

  // vmap and vmapOr help writing pipelines with nullable values
  nullable
      .vmapOr((s) => 'Some $s', () => 'default value')
      .vmap((v) => 'v not null here: ${v.hashCode}')
      .apply$(print) // use side-effect operations with apply/apply$
      .vmap(
          (s) => print(s.toUpperCase())); // prints 'V NOT NULL HERE: 305987627'

  // `not` can be used to negate a predicate
  bool isEven(int n) => n % 2 == 0;
  final isOdd = isEven.not$;
  print([1, 2, 3, 4].where(isOdd)); // prints (1, 3)

  // convert Exceptions to values to enforce error checking
  final result = catching$(() => 'function that may throw');

  // pattern match to get a value out of Result
  print(switch (result) {
    Ok(value: var v) => 'Success: $v',
    Fail(exception: var e) => 'FAILURE: $e',
  });

  // or use the getters
  print('Result is error? ${result.isError}, '
      'success: ${result.successOrNull}, '
      'failure: ${result.failureOrNull}');

  // Currying Examples

  // given some function
  String subStr(String s, int start, int end) {
    return s.substring(start, end);
  }

  // we can curry the first argument:
  final inputSlice = subStr.curry('My large input text');
  print(inputSlice(0, 2)); // prints "My"
  print(inputSlice(3, 8)); // prints "large"

  // curry works on functions with up to 3 args
  final inputEnd = inputSlice.curry(9);
  print(inputEnd(14)); // prints "input"

  // to curry something other than the first arg, use `rot` then `curry`
  final inputStart = inputSlice.rot().curry(8);
  print(inputStart(3)); // prints "large" again
}

```

## Other interesting helper libraries

* [dart-quiver](https://pub.dev/packages/quiver) - Quiver is a set of utility libraries for Dart that makes using many
  Dart libraries easier and more convenient, or adds additional functionality.
* [fpdart](https://pub.dev/packages/fpdart) - All the main functional programming types and patterns fully documented,
  tested, and with examples.
* [collection](https://pub.dev/packages/collection) - Contains utility functions and classes in the style
  of `dart:collection`
  to make working with collections easier.

**Quiver** has lots of helper utilities grouped in a few libraries:

* `quiver.async`
* `quiver.cache`
* `quiver.check`
* `quiver.collection`
* `quiver.core`
* `quiver.string`
* `quiver.time`

And more...

But no tiny functions like `conveniently`.

**`fpdart`** is a much more comprehensive library for Functional Programming enthusiasts.
`conveniently` doesn't try to provide anything like what `fpdart` does,
(despite providing a few functions that are also helpful when doing FP) so it's a much smaller package.

**`collection`** provides lots of helper functions that work with Dart collections. It's pretty good at that,
which is why `conveniently` does not attempt to provide collections helpers at all.
