import 'dart:typed_data';

import 'package:c2bluetooth/helpers.dart';
import 'package:c2bluetooth/models/workout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  group('parseDuration -', () {
    test('2:05.0', () {
      expect(parseDuration("2:05.0"), Duration(seconds: 125));
    });
    test('1:00.9', () {
      expect(parseDuration("1:00.9"), Duration(minutes: 1, milliseconds: 900));
    });
    test('3:00.2', () {
      expect(parseDuration("3:00.2"), Duration(minutes: 3, milliseconds: 200));
    });
    test('throws FormatException on malformed string', () {
      expect(() => parseDuration('foo'), throwsFormatException);
    });

    test('throws RangeError on negative values', () {
      expect(() => parseDuration('-1:00.0'), throwsRangeError);
    });
  });

  group('splitToWatts -', () {
    test('When split is 2:05.0, should be 179', () {
      var result = splitToWatts(Duration(minutes: 2, seconds: 5));
      expect(result, 179.2);
    });
    test('When split is 1:00.9, should be 1550', () {
      var result = splitToWatts(Duration(minutes: 1, milliseconds: 900));
      expect(result, 1549.6);
    });
    test('When split is 3:00.2, should be almost 60', () {
      var result = splitToWatts(Duration(minutes: 3, milliseconds: 200));
      expect(result, 59.8);
    });

    test('When split is 3:00.0, should be 60', () {
      var result = splitToWatts(Duration(minutes: 3));
      expect(result, 60);
    });
    test('throws RangeError when split is non-positive', () {
      expect(() => splitToWatts(Duration.zero), throwsRangeError);
    });
    test('throws RangeError when split is negative', () {
      expect(() => splitToWatts(Duration(seconds: -5)), throwsRangeError);
    });
  });
  group('wattsToSplit -', () {
    test('When watts is 179, should be 2:05.0', () {
      var result = wattsToSplit(179);
      expect(result, '2:05.0');
    });
    test('When watts is 25, should be 4:01.0', () {
      var result = wattsToSplit(25);
      expect(result, '4:01.0');
    });
    test('When watts is 100, should be 2:31.8', () {
      var result = wattsToSplit(100);
      expect(result, '2:31.8');
    });
    test('When watts is 0, should be 0:00.0', () {
      var result = wattsToSplit(0);
      expect(result, '0:00.0');
    });
    test('When watts is 55555, should be 0:18.5', () {
      var result = wattsToSplit(55555);
      expect(result, '0:18.5');
    });
    test('throws RangeError when watts is negative', () {
      expect(() => wattsToSplit(-10), throwsRangeError);
    });
  });
  group('timeFromBytes -', () {
    test('should convert PM date bytes to DateTime', () {
      final bytes = Uint8List.fromList([156, 42, 1, 14]);
      expect(timeFromBytes(bytes), DateTime(2021, 12, 9, 14, 1));
    });

    test('should convert another valid byte sequence', () {
      final bytes = Uint8List.fromList([241, 45, 1, 14]);
      expect(timeFromBytes(bytes), DateTime(2022, 1, 31, 14, 1));
    });
  });

  group('durationToSplit -', () {
    test('converts a 2:05 duration', () {
      expect(durationToSplit(Duration(minutes: 2, seconds: 5)), '2:05.0');
    });

    test('handles seconds only', () {
      expect(durationToSplit(Duration(seconds: 30)), '0:30.0');
    });

    test('handles fractional seconds', () {
      expect(
          durationToSplit(Duration(minutes: 1, milliseconds: 900)), '1:00.9');
    });
  });
}
