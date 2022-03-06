import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

import '../helpers.dart';
import '../models/enums.dart';

/// Represents a summary of a completed workout
///
/// This takes care of processesing the raw byte data from workout summary characteristics into easily accessible fields. This class also takes care of things like byte endianness, combining multiple high and low bytes .etc, allowing applications to access things in terms of flutter native types.
class WorkoutSummary {
  final DateTime timestamp;
  final double workTime;
  final double workDistance;
  final int avgSPM;
  final int endHeartRate;
  final int avgHeartRate;
  final int minHeartRate;
  final int maxHeartRate;
  final int avgDragFactor;
  //recoveryHeartRate is sent as an amended packet later. zero is not valid
  int? recoveryHeartRate;
  final WorkoutType workoutType;
  final double avgPace;
  IntervalType? intervalType;
  int? intervalSize;
  int? intervalCount;
  int? totalCalories;
  int? watts;
  int? totalRestDistance;
  int? intervalRestTime;
  int? avgCalories;

  /// Construct a WorkoutSummary from the bytes returned from the erg
  WorkoutSummary.fromBytes(Uint8List data)
      : timestamp = timeFromBytes(data.sublist(0, 4)),
        workTime = CsafeIntExtension.fromBytes(data.sublist(4, 7),
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
        //recovery heart rate here
        workoutType = WorkoutTypeExtension.fromInt(data.elementAt(17)),
        avgPace = CsafeIntExtension.fromBytes(data.sublist(18, 20),
                endian: Endian.little) /
            10 {
    if (data.length > 20) {
      var timestamp2 = timeFromBytes(data.sublist(20, 24));
      if (timestamp != timestamp2) {
        throw ArgumentError(
            "Bytes passed to WorkoutSummary from multiple characteristics must have the same timestamp");
      }
      intervalType = IntervalTypeExtension.fromInt(data.elementAt(24));
      intervalSize = CsafeIntExtension.fromBytes(data.sublist(25, 27),
          endian: Endian.little);
      intervalCount = data.elementAt(27);
      totalCalories = CsafeIntExtension.fromBytes(data.sublist(28, 30),
          endian: Endian.little);
      watts = CsafeIntExtension.fromBytes(data.sublist(30, 32),
          endian: Endian.little);
      totalRestDistance = CsafeIntExtension.fromBytes(data.sublist(32, 35),
          endian: Endian.little);
      intervalRestTime = CsafeIntExtension.fromBytes(data.sublist(35, 37),
          endian: Endian.little);
      avgCalories = CsafeIntExtension.fromBytes(data.sublist(37, 39),
          endian: Endian.little);
    }
  }

  @override
  String toString() => "WorkoutSummary ("
      "Timestamp: $timestamp, "
      "elapsedTime: $workTime, "
      "distance: $workDistance, "
      "avgSPM: $avgSPM)";
}
