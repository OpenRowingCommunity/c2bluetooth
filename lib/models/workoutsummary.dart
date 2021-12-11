import 'dart:typed_data';

import '../helpers.dart';

/// Processes the raw byte data from workout summary characteristics into easily accessible fields
///
/// This takes care of dealing with byte endianness, combining multiple high and low bytes .etc so that applications using the data only have to deal with flutter [int] types
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
  // final int recoveryHeartRate; //this is sent as an amended packet later. zero is not valid
  // final int workoutType;

  WorkoutSummary.fromBytes(Uint8List data)
      : timestamp = timeFromBytes(data.sublist(0, 4)),
        workTime = bytesToInt(data.sublist(4, 7), Endian.little) /
            100, //divide by 100 to convert to seconds
        workDistance = bytesToInt(data.sublist(7, 10), Endian.little) /
            10, //divide by 10 to convert to meters
        avgSPM = data.sublist(10, 11).first,
        endHeartRate = data.sublist(11, 12).first,
        avgHeartRate = data.sublist(12, 13).first,
        minHeartRate = data.sublist(13, 14).first,
        maxHeartRate = data.sublist(14, 15).first,
        avgDragFactor = data.sublist(15, 16).first;

  @override
  String toString() => "WorkoutSummary ("
      "Timestamp: $timestamp, "
      "elapsedTime: $workTime, "
      "distance: $workDistance, "
      "avgSPM: $avgSPM)";
}
