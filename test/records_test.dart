import 'package:conveniently/conveniently.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Records', () {
    test('passTo', () {
      expect((1,).passTo(_f0), 1);
      expect((1, 2).passTo(_f1), 3);
      expect((1, 2, 3).passTo(_f2), 6);
      expect((1, 2, 3, 4).passTo(_f3), 10);
      expect((1, 2, 3, 4, 5).passTo(_f4), 15);
      expect((1, 2, 3, 4, 5, 6).passTo(_f5), 21);
      expect((1, 2, 3, 4, 5, 6, 7).passTo(_f6), 28);
      expect((1, 2, 3, 4, 5, 6, 7, 8).passTo(_f7), 36);
    });

    test('passTo async', () async {
      Future<String> asyncFun(String a, int b) async => "$a => $b";
      Future<String> result = ("a", 2).passTo(asyncFun);
      expect(await result, "a => 2");
    });
  });
}

int _f0(int a) => a;

int _f1(int a, int b) => a + b;

int _f2(int a, int b, int c) => a + b + c;

int _f3(int a, int b, int c, int d) => a + b + c + d;

int _f4(int a, int b, int c, int d, int e) => a + b + c + d + e;

int _f5(int a, int b, int c, int d, int e, int f) => a + b + c + d + e + f;

int _f6(int a, int b, int c, int d, int e, int f, int g) =>
    a + b + c + d + e + f + g;

int _f7(int a, int b, int c, int d, int e, int f, int g, int h) =>
    a + b + c + d + e + f + g + h;
