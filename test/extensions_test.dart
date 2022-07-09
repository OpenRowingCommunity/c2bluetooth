import 'dart:typed_data';

import 'package:c2bluetooth/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Concept2DateExtension - ", () {
    test('converting a time from bytes', () {
      final bytes = Uint8List.fromList([156, 42, 1, 14]); //date 10908
      expect(
          Concept2DateExtension.fromBytes(bytes), DateTime(2021, 12, 9, 14, 1));
      // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
    });

    test('converting another time from bytes', () {
      final bytes = Uint8List.fromList([241, 45, 1, 14]);
      expect(
          Concept2DateExtension.fromBytes(bytes), DateTime(2022, 1, 31, 14, 1));
      // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
    });

    test('converting a date in 2022 from bytes', () {
      final bytes = Uint8List.fromList([133, 44, 14, 14]);
      expect(
          Concept2DateExtension.fromBytes(bytes), DateTime(2022, 5, 8, 14, 14));
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
