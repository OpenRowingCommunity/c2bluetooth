import 'dart:typed_data';

import '../helpers.dart';

/// Processes the raw byte data from workout summary characteristics into easily accessible fields
///
/// This takes care of dealing with byte endianness, combining multiple high and low bytes .etc so that applications using the data only have to deal with flutter [int] types
class WorkoutSummary {
  final int date;
  final int time;
  final int elapsedTime;
  final double distance;
  final int avgSPM;
  // final int endHeartRate;
  // final int avgHeartRate;
  // final int minHeartRate;
  // final int maxHeartRate;
  // final int avg_drag_factor;
  // final int recoveryHeartRate; //this is sent as an amended packet later. zero is not valid
  // final int workoutType;

  WorkoutSummary.fromBytes(Uint8List data)
      : date = bytesToInt(data.sublist(0, 2), Endian.little),
        time = bytesToInt(data.sublist(2, 4), Endian.little),
        elapsedTime = bytesToInt(data.sublist(4, 7), Endian.little),
        distance = bytesToInt(data.sublist(7, 10), Endian.little) /
            10, //divide by 10 to convert to meters
        avgSPM = bytesToInt(data.sublist(10, 11), Endian.little);
  @override
  String toString() => "WorkoutSummary ("
      "Date: $date, "
      "Time: $time, "
      "elapsedTime: $elapsedTime, "
      "distance: $distance, "
      "avgSPM: $avgSPM)";
}
