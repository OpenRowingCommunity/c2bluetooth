import 'dart:typed_data';
import 'dart:async';

import 'package:c2bluetooth/extensions.dart';
import 'package:csafe_fitness/csafe_fitness.dart';

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

  WorkoutSummary.fromBytes(Uint8List data) {
    _setBasicBytes(data.sublist(0, 20));
    if (data.length > 20) {
      _setExtendedBytes(data.sublist(20));
    }
  }

  /// Construct a WorkoutSummary from the bytes returned from the erg
  void _setBasicBytes(Uint8List data) {
    _timestamp.complete(Concept2DateExtension.fromBytes(data.sublist(0, 4)));
    _workTime.complete(
        CsafeIntExtension.fromBytes(data.sublist(4, 7), endian: Endian.little) /
            100); //divide by 100 to convert to seconds
    _workDistance.complete(CsafeIntExtension.fromBytes(data.sublist(7, 10),
            endian: Endian.little) /
        10); //divide by 10 to convert to meters
    _avgSPM.complete(data.elementAt(10));
    _endHeartRate.complete(data.elementAt(11));
    _avgHeartRate.complete(data.elementAt(12));
    _minHeartRate.complete(data.elementAt(13));
    _maxHeartRate.complete(data.elementAt(14));
    _avgDragFactor.complete(data.elementAt(15));
    //recovery heart rate here
    int recHRVal = data.elementAt(16);
    // 0 is not a valid value here according to the spec
    if (recHRVal > 0) {
      _recoveryHeartRate.complete(recHRVal);
    }
    _workoutType.complete(WorkoutTypeExtension.fromInt(data.elementAt(17)));
    _avgPace.complete(CsafeIntExtension.fromBytes(data.sublist(18, 20),
            endian: Endian.little) /
        10); //{
  }

  void _setExtendedBytes(Uint8List data) {
    // if (data.length > 20) {
    //   var timestamp2 = Concept2DateExtension.fromBytes(data.sublist(20, 24));
    //   if (timestamp != timestamp2) {
    //     throw ArgumentError(
    //         "Bytes passed to WorkoutSummary from multiple characteristics must have the same timestamp");
    //   }
    _intervalType.complete(IntervalTypeExtension.fromInt(data.elementAt(4)));
    _intervalSize.complete(
        CsafeIntExtension.fromBytes(data.sublist(5, 7), endian: Endian.little));
    _intervalCount.complete(data.elementAt(7));
    _totalCalories.complete(CsafeIntExtension.fromBytes(data.sublist(8, 10),
        endian: Endian.little));
    _watts.complete(CsafeIntExtension.fromBytes(data.sublist(10, 12),
        endian: Endian.little));
    _totalRestDistance.complete(CsafeIntExtension.fromBytes(
        data.sublist(12, 15),
        endian: Endian.little));
    _intervalRestTime.complete(CsafeIntExtension.fromBytes(data.sublist(15, 17),
        endian: Endian.little));
    _avgCalories.complete(CsafeIntExtension.fromBytes(data.sublist(17, 19),
        endian: Endian.little));
  }

  @override
  String toString() => "WorkoutSummary ("
      "Timestamp: $timestamp, "
      "elapsedTime: $workTime, "
      "distance: $workDistance, "
      "avgSPM: $avgSPM)";
}
