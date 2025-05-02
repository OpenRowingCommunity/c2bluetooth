import 'dart:typed_data';

import 'package:c2bluetooth/c2bluetooth.dart';
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

    List<int> bothSets = basicBytes + extendedBytes;

    test('can extract basic values from a workout summary byte list', () {
      final summary = WorkoutSummary.fromBytes(Uint8List.fromList(basicBytes));
      expect(summary.timestamp, completion(equals(DateTime(2000, 0, 0, 0, 0))));
      expect(summary.workTime, completion(equals(1.28)));
      expect(summary.workDistance, completion(equals(25.5)));
      expect(summary.avgSPM, completion(equals(32)));
      expect(summary.endHeartRate, completion(equals(190)));
      expect(summary.avgHeartRate, completion(equals(170)));
      expect(summary.minHeartRate, completion(equals(68)));
      expect(summary.maxHeartRate, completion(equals(190)));
      expect(summary.avgDragFactor, completion(equals(120)));
      expect(
          summary.workoutType, completion(equals(WorkoutType.JUSTROW_SPLITS)));
      expect(summary.avgPace, completion(equals(10)));
      //expect(summary.watts, completion(equals(null))); //FIXME: future should not resolve
    });

    test(
        'can extract basic and extended values from a workout summary byte list',
        () {
      final summary = WorkoutSummary.fromBytes(Uint8List.fromList(bothSets));
      // expect(summary.timestamp, DateTime(2000, 0, 0, 0, 0));
      expect(summary.intervalType, completion(equals(IntervalType.TIME)));
      expect(summary.intervalSize, completion(equals(255)));
      expect(summary.intervalCount, completion(equals(2)));
      expect(summary.totalCalories, completion(equals(34)));
      expect(summary.watts, completion(equals(196)));
      expect(summary.totalRestDistance, completion(equals(72)));
      expect(summary.intervalRestTime, completion(equals(55)));
      expect(summary.avgCalories, completion(equals(100)));
    });

    test('fails if it receives two different datetime values', () {
      List<int> modifiedDateBytes = [
        42,
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

      Uint8List differentSets =
          Uint8List.fromList(basicBytes + modifiedDateBytes);

      expect(
          () => WorkoutSummary.fromBytes(differentSets), throwsArgumentError);
    });
  });
}
