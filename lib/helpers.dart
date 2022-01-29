import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

DateTime timeFromBytes(Uint8List bytes) {
  int date = CsafeIntExtension.fromBytes(bytes.sublist(0, 1));

  int day = (date & 0xF0) >> 4;
  int month = date & 0x0F;
  int year = CsafeIntExtension.fromBytes(bytes.sublist(1, 2));
  int minutes = CsafeIntExtension.fromBytes(bytes.sublist(2, 3));
  int hours = CsafeIntExtension.fromBytes(bytes.sublist(3, 4));

  return DateTime((year ~/ 2) + 2000, month, day, hours, minutes);
}
