import 'dart:typed_data';

import 'package:c2bluetooth/models/workoutsummary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('can extract values from a workout summary byte list', () {
    final summary = WorkoutSummary.fromBytes(Uint8List.fromList([
      0,
      0,
      0,
      0,
      128,
      0,
      0,
      255,
      32,
      190,
      170,
      68,
      190,
      120,
      0,
      0,
      0,
      0,
      0
    ]));
    expect(summary.timestamp, DateTime(0, 0, 0, 0, 0));
    expect(summary.workTime, 1.28);
    expect(summary.workDistance, 25.5);
    expect(summary.avgSPM, 32);
    expect(summary.endHeartRate, 190);
    expect(summary.avgHeartRate, 170);
    expect(summary.minHeartRate, 68);
    expect(summary.maxHeartRate, 192);
    expect(summary.avgDragFactor, 120);
  });
}
