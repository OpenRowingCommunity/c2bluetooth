import 'dart:typed_data';

import 'package:c2bluetooth/enums.dart';
import 'package:c2bluetooth/src/helpers.dart';
import 'package:c2bluetooth/src/packets/keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Handle mutliplexed data', () {
    test('parsePacket handles 0x35 StrokeData', () {
      // Construct a byte array representing a packet.
      final data = Uint8List.fromList([
        0x35, // packet ID
        0xE8, 0x03, 0x00, // elapsedTime: 1000 (0x0003E8) => 10 seconds
        0xE8, 0x03, 0x00, // distance: 1000 (0x0003E8) => 100 meters
        0xC8, // drive length: 200 (0x00C8) => 2 meters
        0x64, // drive time: 100 (0x64) => 1 second
        0xE8, 0x03, // recovery time: 1000 (0x03E8) => 10 seconds
        0xE8, 0x03, // stroke distance: 1000 (0x03E8) => 100 meters
        0xA0, 0x0F, // peak force: 4000 (0x0FA0) => 400 lbs
        0xE8, 0x03, // avg force: 1000 (0x3E8) => 100 lbs
        0xE8, 0x03, // stroke count: 1000 (0x3E8)
      ]);
      expect(data.lengthInBytes, equals(19));
      final status = parsePacket(data);
      final map = status!.asMap();
      expect(map[Keys.ELAPSED_TIME_KEY], equals(Duration(seconds: 10)));
      expect(map[Keys.ELAPSED_DISTANCE_KEY], equals(100.0));
      expect(map[Keys.STROKE_DRIVE_LENGTH_KEY], equals(2.0));
      expect(map[Keys.STROKE_DRIVE_TIME_KEY], equals(Duration(seconds: 1)));
      expect(map[Keys.STROKE_RECOVERY_TIME_KEY], equals(Duration(seconds: 10)));
      expect(map[Keys.STROKE_DISTANCE_KEY], equals(100.0));
      expect(map[Keys.STROKE_PEAK_FORCE_KEY], equals(400));
      expect(map[Keys.STROKE_AVG_FORCE_KEY], equals(100));
      expect(map[Keys.STROKE_COUNT_KEY], equals(1000));
    });
    test('parsePacket handles 0x36 StrokeData2', () {
      // Construct a byte array representing a packet.
      final data = Uint8List.fromList([
        0x36, // packet ID
        0xE8, 0x03, 0x00, // elapsedTime: 1000 (0x0003E8) => 10 seconds
        0x54, 0x01, // stroke power: 340 watts
        0x02, 0x00, // stroke calories: 2 cal/hr
        0xE8, 0x03, // stroke count: 1000 strokes
        0x64, 0x00, 0x00, // projected work time: 100 seconds
        0xE8, 0x03, 0x00, // projected work distance: 1000 meters
        0xE8, 0x03, // work per stroke: 1000 (0x03E8) => 100 Joules
      ]);
      expect(data.lengthInBytes, equals(18));
      final status = parsePacket(data);
      final map = status!.asMap();
      expect(map[Keys.ELAPSED_TIME_KEY], equals(Duration(seconds: 10)));
      expect(map[Keys.WORKOUT_POWER_KEY], equals(340));
      expect(map[Keys.WORKOUT_CALORIES_KEY], equals(2.0));
      expect(map[Keys.STROKE_COUNT_KEY], equals(1000));
      expect(
          map[Keys.WORKOUT_PROJECTED_TIME_KEY], equals(Duration(seconds: 100)));
      expect(map[Keys.WORKOUT_PROJECTED_DISTANCE_KEY], equals(1000));
      expect(map[Keys.STROKE_ENERGY_KEY], equals(100.0));
    });
    test('parsePacket handles 0x37 SegmentData1', () {
      // Construct a byte array representing a packet.
      final data = Uint8List.fromList([
        0x37, // packet ID
        0xE8, 0x03, 0x00, // elapsedTime: 1000 (0x0003E8) => 10 seconds
        0xE8, 0x03, 0x00, // elapsedDistance: 1000 (0x0003E8) => 100 meters
        0x88, 0x13, 0x00, // segment time:
        0x88, 0x13, 0x00, // segment distance:
        0x88, 0x13, // interval rest time:
        0x88, 0x13, // interval rest distance:
        0x05, // segment type: rest undefined
        0x03, // segment number:
      ]);
      expect(data.lengthInBytes, equals(19));
      final status = parsePacket(data);
      final map = status!.asMap();
      expect(map[Keys.ELAPSED_TIME_KEY], equals(Duration(seconds: 10)));
      expect(map[Keys.ELAPSED_DISTANCE_KEY], equals(100.0));
      expect(map[Keys.SEGMENT_TIME_KEY], equals(500));
      expect(map[Keys.SEGMENT_DISTANCE_KEY], equals(5000));
      expect(map[Keys.SEGMENT_TYPE_KEY], equals(IntervalType.RESTUNDEFINED));
      expect(map[Keys.SEGMENT_NUMBER_KEY], equals(3));
    });
  });
}
