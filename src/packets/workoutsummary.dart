import 'dart:typed_data';
import 'dart:async';

import 'package:csafe_fitness/csafe_fitness.dart';

import '../../helpers.dart';
import 'package:c2bluetooth/enums.dart';
import './base.dart';

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
  int recoveryHeartRate;
  WorkoutType workoutType;
  double avgPace;

  /// Construct a WorkoutSummary from the bytes returned from the erg
  WorkoutSummary.fromBytes(Uint8List data) : super.fromBytes(data) {
    _workTime =
        CsafeIntExtension.fromBytes(data.sublist(4, 7), endian: Endian.little) /
            100; //divide by 100 to convert to seconds
    _workDistance = CsafeIntExtension.fromBytes(data.sublist(7, 10),
            endian: Endian.little) /
        10; //divide by 10 to convert to meters
    _avgSPM = data.elementAt(10);
    _endHeartRate = data.elementAt(11);
    _avgHeartRate = data.elementAt(12);
    _minHeartRate = data.elementAt(13);
    _maxHeartRate = data.elementAt(14);
    _avgDragFactor = data.elementAt(15);
    //recovery heart rate here
    int recHRVal = data.elementAt(16);
    // 0 is not a valid value here according to the spec
    if (recHRVal > 0) {
      _recoveryHeartRate = recHRVal;
    }
    _workoutType = WorkoutTypeExtension.fromInt(data.elementAt(17));
    _avgPace = CsafeIntExtension.fromBytes(data.sublist(18, 20),
            endian: Endian.little) /
        10;
  }
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

  WorkoutSummary2.fromBytes(Uint8List data) {
    // if (data.length > 20) {
    //   var timestamp2 = Concept2DateExtension.fromBytes(data.sublist(20, 24));
    //   if (timestamp != timestamp2) {
    //     throw ArgumentError(
    //         "Bytes passed to WorkoutSummary from multiple characteristics must have the same timestamp");
    //   }

    intervalType = IntervalTypeExtension.fromInt(data.elementAt(4));
    intervalSize =
        CsafeIntExtension.fromBytes(data.sublist(5, 7), endian: Endian.little);
    intervalCount = data.elementAt(7);
    totalCalories =
        CsafeIntExtension.fromBytes(data.sublist(8, 10), endian: Endian.little);
    watts = CsafeIntExtension.fromBytes(data.sublist(10, 12),
        endian: Endian.little);
    totalRestDistance = CsafeIntExtension.fromBytes(data.sublist(12, 15),
        endian: Endian.little);
    intervalRestTime = CsafeIntExtension.fromBytes(data.sublist(15, 17),
        endian: Endian.little);
    avgCalories = CsafeIntExtension.fromBytes(data.sublist(17, 19),
        endian: Endian.little);
  }

  @override
  String toString() => "WorkoutSummary ("
      "Timestamp: $timestamp, "
      "elapsedTime: $workTime, "
      "distance: $workDistance, "
      "avgSPM: $avgSPM)";
}
