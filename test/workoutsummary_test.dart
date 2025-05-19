import 'dart:typed_data';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:c2bluetooth/data/workoutsummary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("WorkoutSummary Tests", () {
    List<int> basicBytes = [
      0,
      0,
      0,
      0,
      128,
      0,
      0,
      255,
      0,
      0,
      32,
      190,
      170,
      68,
      190,
      120,
      0,
      1,
      100,
      0
    ];

    List<int> extendedBytes = [
      0,
      0,
      0,
      0,
      0,
      255,
      0,
      2,
      34,
      0,
      196,
      0,
      72,
      0,
      0,
      55,
      0,
      100,
      0
    ];

    // List<int> bothSets = basicBytes + extendedBytes;

    test('can extract basic values from a workout summary byte list', () {
      final summary = WorkoutSummary.fromBytes(Uint8List.fromList(basicBytes));
      expect(summary.timestamp, DateTime(2000, 0, 0, 0, 0));
      expect(summary.workTime, 1.28);
      expect(summary.workDistance, 25.5);
      expect(summary.avgSPM, 32);
      expect(summary.endHeartRate, 190);
      expect(summary.avgHeartRate, 170);
      expect(summary.minHeartRate, 68);
      expect(summary.maxHeartRate, 190);
      expect(summary.avgDragFactor, 120);
      expect(summary.workoutType, WorkoutType.JUSTROW_SPLITS);
      expect(summary.avgPace, 10);
    });

    test('can extract extended values from a workout summary byte list', () {
      final summary =
          WorkoutSummary2.fromBytes(Uint8List.fromList(extendedBytes));
      expect(summary.timestamp, DateTime(2000, 0, 0, 0, 0));
      expect(summary.intervalType, IntervalType.TIME);
      expect(summary.intervalSize, 255);
      expect(summary.intervalCount, 2);
      expect(summary.totalCalories, 34);
      expect(summary.watts, 196);
      expect(summary.totalRestDistance, 72);
      expect(summary.intervalRestTime, 55);
      expect(summary.avgCalories, 100);
    });

    // test('fails if it receives two different datetime values', () {
    //   List<int> modifiedDateBytes = [
    //     42,
    //     0,
    //     0,
    //     0,
    //     0,
    //     255,
    //     0,
    //     2,
    //     34,
    //     0,
    //     196,
    //     0,
    //     72,
    //     0,
    //     0,
    //     55,
    //     0,
    //     100,
    //     0
    //   ];

    //   Uint8List differentSets =
    //       Uint8List.fromList(basicBytes + modifiedDateBytes);

    //   expect(
    //       () => WorkoutSummary.fromBytes(differentSets), throwsArgumentError);
    // });
  });
}
