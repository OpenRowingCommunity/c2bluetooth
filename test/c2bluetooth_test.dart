import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:c2bluetooth/c2bluetooth.dart';

void main() {
  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });

  test('can extract values from a workout summary byte list', () {
    final summary = WorkoutSummary.fromBytes(Uint8List.fromList(
        [0, 0, 0, 128, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
    expect(summary.elapsedTime, 128);
    expect(summary.distance, 255);
  });
}
