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

DateTime timeFromBytes(Uint8List bytes) {
  int date = bytesToInt(bytes.sublist(0, 1));

  int day = (date & 0xF0) >> 4;
  int month = date & 0x0F;
  int year = bytesToInt(bytes.sublist(1, 2));
  int minutes = bytesToInt(bytes.sublist(2, 3));
  int hours = bytesToInt(bytes.sublist(3, 4));

  return DateTime(year ~/ 2, month, day, hours, minutes);
}
