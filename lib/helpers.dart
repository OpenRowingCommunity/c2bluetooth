import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

/// Converts Concept2's byte layout for a piece timestamp from bluetooth into a [DateTime]
/// Concept2's structure is date LO, Date HI, Time LO, Time HI
/// see also https://www.c2forum.com/viewtopic.php?f=15&t=200769
DateTime timeFromBytes(Uint8List bytes) {
  int date = CsafeIntExtension.fromBytes(bytes.sublist(0, 2));

  int month = date & 0x0F;
  int day = (date >> 4) & 0x1F;
  int year = (date >> 9) & 0x7f;

  int minutes = CsafeIntExtension.fromBytes(bytes.sublist(2, 3));
  int hours = CsafeIntExtension.fromBytes(bytes.sublist(3, 4));

  return DateTime(year + 2000, month, day, hours, minutes);
}
