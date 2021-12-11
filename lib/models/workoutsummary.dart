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
  //recoveryHeartRate is sent as an amended packet later. zero is not valid
  int? recoveryHeartRate;
  // final int workoutType;

  WorkoutSummary.fromBytes(Uint8List data)
      : timestamp = timeFromBytes(data.sublist(0, 4)),
        workTime = bytesToInt(data.sublist(4, 7), Endian.little) /
            100, //divide by 100 to convert to seconds
        workDistance = bytesToInt(data.sublist(7, 10), Endian.little) /
            10, //divide by 10 to convert to meters
        avgSPM = data.elementAt(10),
        endHeartRate = data.elementAt(11),
        avgHeartRate = data.elementAt(12),
        minHeartRate = data.elementAt(13),
        maxHeartRate = data.elementAt(14),
        avgDragFactor = data.elementAt(15);

  @override
  String toString() => "WorkoutSummary ("
      "Timestamp: $timestamp, "
      "elapsedTime: $workTime, "
      "distance: $workDistance, "
      "avgSPM: $avgSPM)";
}
