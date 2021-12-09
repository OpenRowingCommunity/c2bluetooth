import 'dart:typed_data';

import '../helpers.dart';

/// Processes the raw byte data from workout summary characteristics into easily accessible fields
///
/// This takes care of dealing with byte endianness, combining multiple high and low bytes .etc so that applications using the data only have to deal with flutter [int] types
class WorkoutSummary {
  final int elapsedTime;
  final int distance;

  WorkoutSummary.fromBytes(Uint8List data)
      : elapsedTime = bytesToInt(data.sublist(4, 7), Endian.little),
        distance = bytesToInt(data.sublist(7, 10), Endian.little);
}
