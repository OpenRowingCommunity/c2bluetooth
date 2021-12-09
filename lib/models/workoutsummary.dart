import 'dart:typed_data';

import '../helpers.dart';

/// Processes the raw byte data from workout summary characteristics into easily accessible fields
///
/// This takes care of dealing with byte endianness, combining multiple high and low bytes .etc so that applications using the data only have to deal with flutter [int] types
class WorkoutSummary {
  final int date;
  final int time;
  final int elapsedTime;
  final int distance;
  final int avgSPM;

  WorkoutSummary.fromBytes(Uint8List data)
      : date = bytesToInt(data.sublist(0, 2), Endian.little),
        time = bytesToInt(data.sublist(2, 4), Endian.little),
        elapsedTime = bytesToInt(data.sublist(4, 7), Endian.little),
        distance = bytesToInt(data.sublist(7, 10), Endian.little),
        avgSPM = bytesToInt(data.sublist(10, 11), Endian.little);
}
