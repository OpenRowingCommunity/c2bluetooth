import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

DateTime timeFromBytes(Uint8List bytes) {
  int date = CsafeIntExtension.fromBytes(bytes.sublist(0, 2));
  int year = date >> 9;

  int day = (date >> 4) & 0x1F;
  int month = date & 0x0F;

  int minutes = CsafeIntExtension.fromBytes(bytes.sublist(2, 3));
  int hours = CsafeIntExtension.fromBytes(bytes.sublist(3, 4));

  return DateTime(year + 2000, month, day, hours, minutes);
}
