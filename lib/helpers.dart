import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

import 'models/workout.dart';

/// Converts Concept2's byte layout for a piece timestamp from bluetooth into a [DateTime]
/// Concept2's structure is date LO, Date HI, Time LO, Time HI
/// see also https://www.c2forum.com/viewtopic.php?f=15&t=200769
DateTime timeFromBytes(Uint8List bytes) {
  int date =
      CsafeIntExtension.fromBytes(bytes.sublist(0, 2), endian: Endian.little);

  int month = date & 0x0F;
  int day = (date >> 4) & 0x1F;
  int year = (date >> 9) & 0x7f;

  int minutes =
      CsafeIntExtension.fromBytes(bytes.sublist(2, 3), endian: Endian.little);
  int hours =
      CsafeIntExtension.fromBytes(bytes.sublist(3, 4), endian: Endian.little);

  return DateTime(year + 2000, month, day, hours, minutes);
}

/// Attempt to guess a reasonable split value from a given workout
///
/// The minimum split duration must not cause the total number of splits per workout to exceed the maximum of 50.
WorkoutGoal? guessReasonableSplit(WorkoutGoal goal) {
  int firstSplittableCount = 0;

  for (var i = 4; i <= 50; i++) {
    if (goal.length % i == 0) {
      firstSplittableCount = i;
      break;
    }
  }

  if (firstSplittableCount == 0) {
    return null;
  }

  return WorkoutGoal(goal.length ~/ firstSplittableCount, goal.type);
}

//https://stackoverflow.com/questions/54852585/how-to-convert-a-duration-like-string-to-a-real-duration-in-flutter
Duration parseDuration(String s) {
  final parts = s.split(':');
  if (parts.length < 2 || parts.length > 3) {
    throw const FormatException('Invalid duration format');
  }

  final secString = parts.last;
  final sec = double.tryParse(secString);
  if (sec == null) {
    throw const FormatException('Invalid seconds value');
  }

  final minString = parts[parts.length - 2];
  final minutes = int.tryParse(minString);
  if (minutes == null) {
    throw const FormatException('Invalid minutes value');
  }

  int hours = 0;
  if (parts.length == 3) {
    hours = int.tryParse(parts.first) ??
        (throw const FormatException('Invalid hours value'));
  }

  if (hours < 0 || minutes < 0 || sec < 0) {
    throw RangeError('Duration values must be non-negative');
  }

  final micros = (sec * Duration.microsecondsPerSecond).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

String durationToSplit(Duration d) {
  List<String> durSplit = d.toString().split('.');
  List<String> time = durSplit.first.split(":");
  String millis = durSplit.last.substring(0, 1);
  // print(millis);

  return "${d.inMinutes}:${time.last.padLeft(2, "0")}.$millis";
}

//conversion functions for watts and split (from crewlab app)
//There's funny rounding in these formulas that seemed to match what concept 2 does for their calculations  (edited). You may not want to bring that in to the plug-in
// watts = 2.80 / pace^3; pace = seconds per meter
// source: https://www.concept2.com/indoor-rowers/training/calculators/watts-calculator

double splitToWatts(Duration split) {
  if (split.inMilliseconds <= 0) {
    throw RangeError('split must be positive');
  }
  double secondsperMeter =
      split.inMilliseconds / Duration.millisecondsPerSecond;
  var rawWatts = (2.8 / pow(secondsperMeter / 500, 3));
  return double.parse(rawWatts.toStringAsFixed(1));
}

// pace = ³√(2.80/watts); pace = seconds per meter
// source: https://www.concept2.com/indoor-rowers/training/calculators/watts-calculator
String wattsToSplit(double watts) {
  if (watts < 0) {
    throw RangeError('watts must be non-negative');
  }
  if (watts == 0) {
    return "0:00.0";
  }
  var pace = pow((2.80 / watts), (1 / 3)).toDouble();
  var seconds = (pace * 500.0 * 10.0).round() / 10.0;
  var millis = (seconds * Duration.millisecondsPerSecond).round();
  var split = durationToSplit(Duration(milliseconds: millis));
  return split;
}
