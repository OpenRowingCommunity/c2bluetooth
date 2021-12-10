import 'dart:typed_data';

import '../helpers.dart';

/// Processes the raw byte data from workout summary characteristics into easily accessible fields
///
/// This takes care of dealing with byte endianness, combining multiple high and low bytes .etc so that applications using the data only have to deal with flutter [int] types
class WorkoutSummary {
  final DateTime timestamp;
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
      : timestamp = timeFromBytes(data.sublist(0, 4)),
        elapsedTime = bytesToInt(data.sublist(4, 7), Endian.little),
        distance = bytesToInt(data.sublist(7, 10), Endian.little) /
            10, //divide by 10 to convert to meters
        avgSPM = bytesToInt(data.sublist(10, 11), Endian.little);
  @override
  String toString() => "WorkoutSummary ("
      "Timestamp: $timestamp, "
      "elapsedTime: $elapsedTime, "
      "distance: $distance, "
      "avgSPM: $avgSPM)";
}

DateTime timeFromBytes(Uint8List bytes) {
  int date = bytesToInt(bytes.sublist(0, 1));

  int day = (date & 0xF0) >> 4;
  int month = date & 0x0F;
  int year = bytesToInt(bytes.sublist(1, 2));
  int minutes = bytesToInt(bytes.sublist(2, 3));
  int hours = bytesToInt(bytes.sublist(3, 4));

  return DateTime(year ~/ 2, month, day, hours, minutes);
}
