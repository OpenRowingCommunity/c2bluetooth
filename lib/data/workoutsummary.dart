import 'dart:typed_data';
import 'dart:async';

import 'package:c2bluetooth/extensions.dart';
import 'package:csafe_fitness/csafe_fitness.dart';

import '../helpers.dart';
import 'package:c2bluetooth/enums.dart';

///Represents a data packet from Concept2 that is stamped with a date.
class TimestampedData {
  DateTime timestamp;

  TimestampedData.fromBytes(Uint8List bytes)
      : timestamp = Concept2DateExtension.fromBytes(bytes.sublist(0, 4));
}

///Represents a data packet from Concept2 that is stamped with a duration.

class DurationstampedData {
  Duration elapsedTime;

  DurationstampedData.fromBytes(Uint8List data)
      : elapsedTime = Concept2DurationExtension.fromBytes(data.sublist(0, 3));
}

/// Represents a summary of a completed workout
///
/// This takes care of processesing the raw byte data from workout summary characteristics into easily accessible fields. This class also takes care of things like byte endianness, combining multiple high and low bytes .etc, allowing applications to access things in terms of flutter native types.
class WorkoutSummary extends TimestampedData {
  double workTime;
  double workDistance;
  int avgSPM;
  int endHeartRate;
  int avgHeartRate;
  int minHeartRate;
  int maxHeartRate;
  int avgDragFactor;
  late int recoveryHeartRate;
  WorkoutType workoutType;
  double avgPace;

  /// Construct a WorkoutSummary from the bytes returned from the erg
  WorkoutSummary.fromBytes(Uint8List data)
      : workTime = CsafeIntExtension.fromBytes(data.sublist(4, 7),
                endian: Endian.little) /
            100, //divide by 100 to convert to seconds
        workDistance = CsafeIntExtension.fromBytes(data.sublist(7, 10),
                endian: Endian.little) /
            10, //divide by 10 to convert to meters
        avgSPM = data.elementAt(10),
        endHeartRate = data.elementAt(11),
        avgHeartRate = data.elementAt(12),
        minHeartRate = data.elementAt(13),
        maxHeartRate = data.elementAt(14),
        avgDragFactor = data.elementAt(15),
        workoutType = WorkoutTypeExtension.fromInt(data.elementAt(17)),
        avgPace = CsafeIntExtension.fromBytes(data.sublist(18, 20),
                endian: Endian.little) /
            10,
        super.fromBytes(data) {
    //recovery heart rate here
    int recHRVal = data.elementAt(16);
    // 0 is not a valid value here according to the spec
    if (recHRVal > 0) {
      recoveryHeartRate = recHRVal;
    }
  }

  @override
  String toString() => "WorkoutSummary ("
      "Timestamp: $timestamp, "
      "elapsedTime: $workTime, "
      "distance: $workDistance, "
      "avgSPM: $avgSPM)";
}

class WorkoutSummary2 {
  IntervalType intervalType;
  int intervalSize;
  int intervalCount;
  int totalCalories;
  int watts;
  int totalRestDistance;
  int intervalRestTime;
  int avgCalories;

  WorkoutSummary2.fromBytes(Uint8List data)
      :
        // if (data.length > 20) {
        //   var timestamp2 = Concept2DateExtension.fromBytes(data.sublist(20, 24));
        //   if (timestamp != timestamp2) {
        //     throw ArgumentError(
        //         "Bytes passed to WorkoutSummary from multiple characteristics must have the same timestamp");
        //   }

        intervalType = IntervalTypeExtension.fromInt(data.elementAt(4)),
        intervalSize = CsafeIntExtension.fromBytes(data.sublist(5, 7),
            endian: Endian.little),
        intervalCount = data.elementAt(7),
        totalCalories = CsafeIntExtension.fromBytes(data.sublist(8, 10),
            endian: Endian.little),
        watts = CsafeIntExtension.fromBytes(data.sublist(10, 12),
            endian: Endian.little),
        totalRestDistance = CsafeIntExtension.fromBytes(data.sublist(12, 15),
            endian: Endian.little),
        intervalRestTime = CsafeIntExtension.fromBytes(data.sublist(15, 17),
            endian: Endian.little),
        avgCalories = CsafeIntExtension.fromBytes(data.sublist(17, 19),
            endian: Endian.little) {}
}
