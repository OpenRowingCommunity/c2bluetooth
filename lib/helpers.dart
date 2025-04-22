import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

import 'models/workout.dart';

/// Converts Concept2's byte layout for a piece timestamp from bluetooth into a [DateTime]
/// Concept2's structure is date LO, Date HI, Time LO, Time HI
/// see also https://www.c2forum.com/viewtopic.php?f=15&t=200769
DateTime timeFromBytes(Uint8List bytes) {
  int date = CsafeIntExtension.fromBytes(bytes.sublist(0, 2));

  int month = date & 0x0F;
  int day = (date >> 4) & 0x1F;
  int year = (date >> 9) & 0x7f;

  int minutes = CsafeIntExtension.fromBytes(bytes.sublist(2, 3));
  int hours = CsafeIntExtension.fromBytes(bytes.sublist(3, 4));

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
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).toInt();
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
  double secondsperMeter =
      split.inMilliseconds / Duration.millisecondsPerSecond;
  var rawWatts = (2.8 / pow(secondsperMeter / 500, 3));
  return double.parse(rawWatts.toStringAsFixed(1));
}

// pace = ³√(2.80/watts); pace = seconds per meter
// source: https://www.concept2.com/indoor-rowers/training/calculators/watts-calculator
String wattsToSplit(double watts) {
  if (watts == 0) {
    return "0:00.0";
  }
  var pace = pow((2.80 / watts), (1 / 3)).toDouble();
  var seconds = (pace * 500.0 * 10.0).round() / 10.0;
  var millis = (seconds * Duration.millisecondsPerSecond).round();
  var split = durationToSplit(Duration(milliseconds: millis));
  return split;
}
