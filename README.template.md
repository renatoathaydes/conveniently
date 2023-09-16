-- This is a template!
-- run dart run generate_readme.dart to generate README.md from this file
# Conveniently.

Write Dart code more conveniently.

This is a tiny package that offers some very convenient utilities that you may use quite often
once you know they exist.

> A few functions have both synchronous and async versions. In such cases, the synchronous
> function's name appends `$` to the async function's name.
> The Dart stdlib normally adds the `Sync` suffix in such cases, but I thought `$` would be
> a better suffix as it's shorter and I can quickly internalize it as meaning `Sync` in my head. 

## Types

### `Result<V>`

The only type it exports is `Result`, for error checking, which you normally obtain by calling
`catching` or `catching$` (see more examples at the end of this page).

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

You can also create `Result` by invoking its factory methods:

```dart
Result<String> result;
result = Result.ok('yes');
result = Result.fail(FormatException());
```

## Top-level functions

* `timing`    - time a computation (asynchronous).
* `timing$`   - time a computation (synchronous).
* `catching`  - enforce error handling (asynchronous).
* `catching$`  - enforce error handling (synchronous).

## Extension functions

### on `<T>` (any type, including nullable types)

* `vmap`  - map over any value.

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
    // using `vmap`:
    return name?.vmap((n) => n.capitilize()) ?? '<No name>';
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

## Examples

```dart
{{ EXAMPLES }}
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
