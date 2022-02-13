import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

DateTime timeFromBytes(Uint8List bytes) {
  int date = CsafeIntExtension.fromBytes(bytes.sublist(1, 2));
  int year_bytes = CsafeIntExtension.fromBytes(bytes.sublist(0, 1));
  int year = year_bytes >> 1;

  int day = ((year_bytes & 0x01) << 4) | ((date & 0xF0) >> 4);
  int month = date & 0x0F;
  // year = year >> 1;

  int minutes = CsafeIntExtension.fromBytes(bytes.sublist(2, 3));
  int hours = CsafeIntExtension.fromBytes(bytes.sublist(3, 4));

  return DateTime(year + 2000, month, day, hours, minutes);
}
