import 'dart:typed_data';

import 'package:c2bluetooth/csafe/datatypes.dart';
import 'package:c2bluetooth/helpers.dart';
import 'package:c2bluetooth/models/workout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converting a time from bytes', () {
    final bytes = Uint8List.fromList([42, 156, 1, 14]); //date 10908
    expect(timeFromBytes(bytes), DateTime(2021, 12, 9, 14, 1));
    // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
  });

  test('converting another time from bytes', () {
    final bytes = Uint8List.fromList([45, 241, 1, 14]);
    expect(timeFromBytes(bytes), DateTime(2022, 1, 31, 14, 1));
    // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
  });

  group("guessReasonableSplit - ", () {
    test("test with reasonable distance", () {
      expect(guessReasonableSplit(WorkoutGoal.meters(2000)),
          WorkoutGoal.meters(500));
    });

    test("test with reasonable time", () {
      expect(guessReasonableSplit(WorkoutGoal.minutes(30)),
          WorkoutGoal.minutes(6));
    });

    test("test with prime number time", () {
      expect(guessReasonableSplit(WorkoutGoal.minutes(17)),
          WorkoutGoal.minutes(1));
    });
    test("test with prime number > 50", () {
      expect(guessReasonableSplit(WorkoutGoal.minutes(59)), null);
    });
  });
}
