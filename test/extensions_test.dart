import 'dart:typed_data';

import 'package:c2bluetooth/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Concept2DateExtension - ", () {
    test('converting a time from bytes', () {
      final bytes = Uint8List.fromList([156, 42, 1, 14]); //date 10908
      final date = Concept2DateExtension.fromBytes(bytes);
      expect(date, DateTime(2021, 12, 9, 14, 1));
      expect(date.toBytes(), bytes);
    });

    test('converting another time from bytes', () {
      final bytes = Uint8List.fromList([241, 45, 1, 14]);
      final date = Concept2DateExtension.fromBytes(bytes);
      expect(date, DateTime(2022, 1, 31, 14, 1));
      expect(date.toBytes(), bytes);
    });

    test('converting a date from a verifiable source from bytes', () {
      // https://www.c2forum.com/viewtopic.php?t=93684
      //  DateH     DateL     TimeH    TimeL
      // 00011101 10010100  00010000 00001001
      // final bytes = Uint8List.fromList([29, 148, 16, 9]);
      final bytes = Uint8List.fromList([148, 29, 9, 16]);
      final date = Concept2DateExtension.fromBytes(bytes);
      expect(date, DateTime(2014, 4, 25, 16, 09));
      // 25th April 2014 @ 16:09 (4:09pm)
      expect(date.toBytes(), bytes);
    });

    test('converting a date in 2022 from bytes', () {
      final bytes = Uint8List.fromList([133, 44, 14, 14]);
      final date = Concept2DateExtension.fromBytes(bytes);
      expect(date, DateTime(2022, 5, 8, 14, 14));
      expect(date.toBytes(), bytes);
    });
  });

  group("Concept2DurationExtension - ", () {
    // TODO: need bytes to use as test case
    // test('converting a duration from bytes', () {
    //   // TODO: fixme, my endianness is backwards
    //   final bytes = Uint8List.fromList([42, 156, 1, 14]); //date 10908
    //   expect(
    //       Concept2DurationExtension.fromBytes(bytes), DateTime(2021, 12, 9, 14, 1));
    // });
  });
}
