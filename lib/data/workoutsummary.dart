import 'dart:typed_data';
import 'dart:async';

import 'package:csafe_fitness/csafe_fitness.dart';

import '../helpers.dart';
import 'package:c2bluetooth/enums.dart';

/// Represents a summary of a completed workout
///
/// This takes care of processesing the raw byte data from workout summary characteristics into easily accessible fields. This class also takes care of things like byte endianness, combining multiple high and low bytes .etc, allowing applications to access things in terms of flutter native types.
class WorkoutSummary {
  Completer<DateTime> _timestamp = new Completer<DateTime>();
  Completer<double> _workTime = new Completer<double>();
  Completer<double> _workDistance = new Completer<double>();
  Completer<int> _avgSPM = new Completer<int>();
  Completer<int> _endHeartRate = new Completer<int>();
  Completer<int> _avgHeartRate = new Completer<int>();
  Completer<int> _minHeartRate = new Completer<int>();
  Completer<int> _maxHeartRate = new Completer<int>();
  Completer<int> _avgDragFactor = new Completer<int>();
  Completer<int> _recoveryHeartRate = new Completer<int>();
  Completer<WorkoutType> _workoutType = new Completer<WorkoutType>();
  Completer<double> _avgPace = new Completer<double>();
  Completer<IntervalType> _intervalType = new Completer<IntervalType>();
  Completer<int> _intervalSize = new Completer<int>();
  Completer<int> _intervalCount = new Completer<int>();
  Completer<int> _totalCalories = new Completer<int>();
  Completer<int> _watts = new Completer<int>();
  Completer<int> _totalRestDistance = new Completer<int>();
  Completer<int> _intervalRestTime = new Completer<int>();
  Completer<int> _avgCalories = new Completer<int>();

  // external getters for clients to get futures for the data they want
  Future<DateTime> get timestamp => _timestamp.future;
  Future<double> get workTime => _workTime.future;
  Future<double> get workDistance => _workDistance.future;
  Future<int> get avgSPM => _avgSPM.future;
  Future<int> get endHeartRate => _endHeartRate.future;
  Future<int> get avgHeartRate => _avgHeartRate.future;
  Future<int> get minHeartRate => _minHeartRate.future;
  Future<int> get maxHeartRate => _maxHeartRate.future;
  Future<int> get avgDragFactor => _avgDragFactor.future;
  //recoveryHeartRate is sent as an amended packet later. zero is not valid
  Future<int> get recoveryHeartRate => _recoveryHeartRate.future;
  Future<WorkoutType> get workoutType => _workoutType.future;
  Future<double> get avgPace => _avgPace.future;
  Future<IntervalType> get intervalType => _intervalType.future;
  Future<int> get intervalSize => _intervalSize.future;
  Future<int> get intervalCount => _intervalCount.future;
  Future<int> get totalCalories => _totalCalories.future;
  Future<int> get watts => _watts.future;
  Future<int> get totalRestDistance => _totalRestDistance.future;
  Future<int> get intervalRestTime => _intervalRestTime.future;
  Future<int> get avgCalories => _avgCalories.future;

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
