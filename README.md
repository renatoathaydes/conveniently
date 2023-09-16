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
result = Result.ok
('yes
'
);result = Result.fail(FormatException());
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
}

```
