library c2bluetooth;

import 'dart:typed_data';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class WorkoutSummary {
  final int elapsedTime;
  final int distance;

  WorkoutSummary.fromBytes(Uint8List data)
      : elapsedTime = bytesToInt(data.sublist(4, 7), Endian.little),
        distance = bytesToInt(data.sublist(7, 10), Endian.little);
}

/// takes in a sublist of bytes and converts it to an int
int bytesToInt(Uint8List data, [Endian endian = Endian.big]) {
  // if (data.length > 4) => return Error("Data may not be more than 4 bytes");

  // make sure everything is formatted with the Most Significant Byte first.
  if (endian != Endian.big) {
    data = Uint8List.fromList(data.reversed.toList());
  }

  int result = 0;
  for (final datapoint in data) {
    result = result << 8;
    result = result | datapoint;
  }
  return result;
}
