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
