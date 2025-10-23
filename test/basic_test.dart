import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Basic math test - 1+1=2', () {
    expect(1 + 1, 2);
  });
  
  test('List test - 6 numbers', () {
    expect([1, 2, 3, 4, 5, 6].length, 6);
  });
  
  test('String test', () {
    expect('Lotto'.length, 5);
  });
}
