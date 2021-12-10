import 'dart:typed_data';

import 'package:c2bluetooth/models/workoutsummary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('can extract values from a workout summary byte list', () {
    final summary = WorkoutSummary.fromBytes(Uint8List.fromList(
        [0, 0, 0, 0, 128, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
    expect(summary.workTime, 128);
    expect(summary.distance, 25.5);
  });
}
