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
