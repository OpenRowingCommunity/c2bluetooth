import 'dart:typed_data';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:c2bluetooth/enums.dart';
import '../../lib/src/datatypes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tests for Concept2IntegerWithUnits', () {
    Uint8List dead = Uint8List.fromList([0x40, 0xDE, 0xAD]);
    // Uint8List adde = Uint8List.fromList([0x40, 0xAD, 0xDE]);

    Uint8List deadbeef = Uint8List.fromList([0x40, 0xEF, 0xBE, 0xAD, 0xDE]);

    // test('test correct little endian parsing fromBytes', () {
    //   Concept2IntegerWithUnits intUnits =
    //       Concept2IntegerWithUnits.fromBytes(adde);

    //   expect(intUnits.value, 57005);
    //   expect(intUnits.unit, DurationType.DISTANCE);
    // });

    test('test constructors', () {
      expect(
          Concept2IntegerWithUnits.distance(500).unit, DurationType.DISTANCE);
      expect(Concept2IntegerWithUnits.time(500).unit, DurationType.TIME);
      expect(
          Concept2IntegerWithUnits.calories(500).unit, DurationType.CALORIES);
      expect(
          Concept2IntegerWithUnits.wattMinutes(500).unit, DurationType.WATTMIN);
    });

    test('test matchesType', () {
      expect(
          Concept2IntegerWithUnits.distance(500)
              .matchesType(DurationType.DISTANCE),
          true);
      expect(Concept2IntegerWithUnits.time(500).matchesType(DurationType.TIME),
          true);
      expect(
          Concept2IntegerWithUnits.calories(500)
              .matchesType(DurationType.CALORIES),
          true);
      expect(
          Concept2IntegerWithUnits.wattMinutes(500)
              .matchesType(DurationType.WATTMIN),
          true);

      expect(
          Concept2IntegerWithUnits.distance(500).matchesType(DurationType.TIME),
          false);
      expect(
          Concept2IntegerWithUnits.time(500).matchesType(DurationType.CALORIES),
          false);
      expect(
          Concept2IntegerWithUnits.calories(500)
              .matchesType(DurationType.WATTMIN),
          false);
      expect(
          Concept2IntegerWithUnits.wattMinutes(500)
              .matchesType(DurationType.DISTANCE),
          false);
    });

    test('test correct default big endian parsing fromBytes', () {
      Concept2IntegerWithUnits intUnits =
          Concept2IntegerWithUnits.fromBytes(dead);

      expect(intUnits.value, 57005);
      expect(intUnits.unit, DurationType.DISTANCE);
    });

    test('test symmetric parsing short', () {
      Concept2IntegerWithUnits intUnits =
          Concept2IntegerWithUnits.fromBytes(dead);

      expect(intUnits.toBytes(), dead);
    });

    test('test symmetric parsing long', () {
      Concept2IntegerWithUnits intUnits =
          Concept2IntegerWithUnits.fromBytes(deadbeef);

      expect(intUnits.toBytes(), deadbeef);
    });

    test('test correct parsing fromBytes', () {
      Concept2IntegerWithUnits intUnits =
          Concept2IntegerWithUnits.fromBytes(dead);

      expect(intUnits.value, 57005);
      expect(intUnits.unit, DurationType.DISTANCE);
    });

    test('test symmetric parsing short', () {
      Concept2IntegerWithUnits intUnits =
          Concept2IntegerWithUnits.fromBytes(dead);

      expect(intUnits.toBytes(), dead);
    });

    test('test symmetric parsing long', () {
      Concept2IntegerWithUnits intUnits =
          Concept2IntegerWithUnits.fromBytes(deadbeef);

      expect(intUnits.toBytes(), deadbeef);
    });

    // test('test meters constructor generates the right bytes', () {
    //   expect(Concept2IntegerWithUnits.meters(2000).toBytes(),
    //       Uint8List.fromList([0xD0, 0x07, 0x24]));
    // });

    // test('test kilometers constructor generates the right bytes', () {
    //   expect(Concept2IntegerWithUnits.kilometers(2).toBytes(),
    //       Uint8List.fromList([0x02, 0x00, 0x21]));
    // });

    // test('test watts constructor generates the right bytes', () {
    //   expect(Concept2IntegerWithUnits.watts(300).toBytes(),
    //       Uint8List.fromList([0x2C, 0x01, 0x58]));
    // });
  });
}
