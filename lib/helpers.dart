import 'dart:typed_data';

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
