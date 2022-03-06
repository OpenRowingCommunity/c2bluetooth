import 'dart:typed_data';

import 'package:c2bluetooth/csafe/datatypes.dart';
import 'package:c2bluetooth/helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converting a time from bytes', () {
    final bytes = Uint8List.fromList([42, 156, 1, 14]); //date 10908
    expect(timeFromBytes(bytes), DateTime(2021, 12, 9, 14, 1));
    // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
  });

  test('converting another time from bytes', () {
    final bytes = Uint8List.fromList([45, 241, 1, 14]);
    expect(timeFromBytes(bytes), DateTime(2022, 1, 31, 14, 1));
    // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
  });

  group("guessReasonableSplit - ", () {
    test("test with reasonable distance", () {
      expect(guessReasonableSplit(Concept2IntegerWithUnits.distance(2000)),
          Concept2IntegerWithUnits.distance(500));
    });

    test("test with reasonable time", () {
      expect(guessReasonableSplit(Concept2IntegerWithUnits.time(30)),
          Concept2IntegerWithUnits.time(6));
    });

    test("test with prime number time", () {
      expect(guessReasonableSplit(Concept2IntegerWithUnits.time(17)),
          Concept2IntegerWithUnits.time(1));
    });
    test("test with prime number > 50", () {
      expect(guessReasonableSplit(Concept2IntegerWithUnits.time(59)), null);
    });
  });
}
