import 'dart:typed_data';

import 'package:c2bluetooth/csafe/datatypes.dart';
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
