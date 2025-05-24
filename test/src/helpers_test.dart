import 'dart:typed_data';

import 'package:c2bluetooth/enums.dart';
import 'package:c2bluetooth/src/helpers.dart';
import 'package:c2bluetooth/src/packets/keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Handle multiplexed data', () {
    test('parsePacket handles 0x31 StatusData', () {
      // Construct a byte array representing a packet.
      final data = Uint8List.fromList([
        0x31, // packet ID
        0xE8, 0x03, 0x00, // elapsedTime: 1000 (0x0003E8) => 10 seconds
        0xE8, 0x03, 0x00, // distance: 1000 (0x0003E8) => 100 meters
        0x08, // workout type: 0x08 => VARIABLE_INTERVAL
        0x00, // interval type: 0x00 => TIME
        0x03, // workout state: 0x03 => INTERVALREST
        0x00, // rowing state: 0x00 => INACTIVE
        0x00, // stroke state: 0x00 => WAITING_FOR_WHEEL_TO_REACH_MIN_SPEED_STATE
        0xE8, 0x03, 0x00, // distance: 1000 meters
        0x02, 0x03, 0x00, // workout duration: 770 cals
        0x40, // duration type: 0x40 => calories
        0xFF, // drag factor: 0x55 => 255
      ]);
      expect(data.lengthInBytes, equals(20));
      final status = parsePacket(data);
      final map = status!.asMap();
      expect(map[Keys.ELAPSED_TIME_KEY], equals(Duration(seconds: 10)));
      expect(map[Keys.ELAPSED_DISTANCE_KEY], equals(100.0));
      expect(map[Keys.STATE_WORKOUT_TYPE_KEY],
          equals(WorkoutType.VARIABLE_INTERVAL));
      expect(map[Keys.STATE_SEGMENT_TYPE_KEY], equals(IntervalType.TIME));
      expect(map[Keys.STATE_WORKOUT_KEY], equals(WorkoutState.INTERVALREST));
      expect(map[Keys.STATE_ROWING_KEY], equals(RowingState.INACTIVE));
      expect(map[Keys.WORKOUT_DURATION_KEY], equals(770.0));
      expect(
          map[Keys.WORKOUT_DURATION_UNIT_KEY], equals(DurationType.CALORIES));
      expect(map[Keys.STATE_ROWING_STROKE_KEY],
          equals(StrokeState.WAITING_FOR_WHEEL_TO_REACH_MIN_SPEED_STATE));
      expect(map[Keys.WORKOUT_TOTAL_DISTANCE_KEY], equals(1000));
      expect(map[Keys.WORKOUT_DRAG_FACTOR_KEY], equals(255));
    });
    test('parsePacket handles 0x32 StatusData1', () {
      // Construct a byte array representing a packet.
      final data = Uint8List.fromList([
        0x32, // packet ID
        0xE8, 0x03, 0x00, // elapsedTime: 1000 (0x0003E8) => 10 seconds
        0xE8, 0x03, // speed: 1000 (0x03E8) => 1 m/s
        0x2A, // stroke rate: (0x2A) => 42 strokes/min
        0xC4, // heart rate: (0xC4) => 196 bpm
        0xE0, 0x2E, // current pace: 12000 (0x2EE0) => 120 seconds
        0xE5, 0x2E, // average pace: 12005 (0x2EE5) => 120,05 seconds
        0xE5, 0x00, // rest distance: 229 (0x00E5) => 229 meters
        0xB8, 0x0B, 0x00, // rest time: 3000 (0x000BB8) => 30 seconds
        0xE6, 0x00, // average power: 230 (0x00E6) => 230 watts
        0x13, // erg machine type: 19 (0x13) => SLIDES_D
      ]);
      expect(data.lengthInBytes, equals(20));
      final status = parsePacket(data);
      final map = status!.asMap();
      expect(map[Keys.ELAPSED_TIME_KEY], equals(Duration(seconds: 10)));
      expect(map[Keys.WORKOUT_SPEED_KEY], equals(1.0));
      expect(map[Keys.WORKOUT_SPM_KEY], equals(42));
      expect(map[Keys.WORKOUT_HR_KEY], equals(196));
      expect(map[Keys.WORKOUT_PACE_KEY], equals(Duration(minutes: 2)));
      expect(map[Keys.WORKOUT_AVG_PACE_KEY],
          equals(Duration(minutes: 2, milliseconds: 50)));
      expect(map[Keys.WORKOUT_REST_DISTANCE_KEY], equals(229));
      expect(map[Keys.WORKOUT_REST_TIME_KEY], equals(Duration(seconds: 30)));
      expect(map[Keys.WORKOUT_AVG_POWER_KEY], equals(230));
      expect(map[Keys.WORKOUT_MACHINE_TYPE_KEY], equals(MachineType.SLIDES_D));
    });
    test('parsePacket handles 0x33 StatusData2', () {
      // Construct a byte array representing a packet.
      final data = Uint8List.fromList([
        0x33, // packet ID
        0xE8, 0x03, 0x00, // elapsedTime: 1000 (0x0003E8) => 10 seconds
        0x10, // interval count: (0x10) => 16 interval
        0x2D, 0x00, // total calories: (0x002D) => 45 calories
        0x80, 0x3E, // segment avg pace: 16000 (0x03E80) => 160 seconds
        0x0E, 0x01, // segment avg power: (0x010E) => 270 watts
        0x10, 0x00, // segment avg calories: (0x10) => 16 calories
        0x4A, 0x06, 0x00, // last split time: 1610 (0x0000A1) => 161 seconds
        0xF4, 0x01, 0x00, // last split distance: 500 (0x0001F4) => 500 meters
      ]);
      expect(data.lengthInBytes, equals(19));
      final status = parsePacket(data);
      final map = status!.asMap();
      expect(map[Keys.ELAPSED_TIME_KEY], equals(Duration(seconds: 10)));
      expect(map[Keys.SEGMENT_NUMBER_KEY], equals(16));
      expect(map[Keys.WORKOUT_CALORIES_KEY], equals(45));
      expect(map[Keys.SEGMENT_AVG_PACE_KEY], equals(Duration(seconds: 160)));
      expect(map[Keys.SEGMENT_AVG_POWER_KEY], equals(270));
      expect(map[Keys.SEGMENT_AVG_CALORIES_KEY], equals(16));
      expect(map[Keys.SEGMENT_LAST_TIME_KEY], equals(Duration(seconds: 161)));
      expect(map[Keys.SEGMENT_LAST_DISTANCE_KEY], equals(500));
    });
    test('parsePacket handles 0x3E StatusData3', () {
      // Construct a byte array representing a packet.
      final data = Uint8List.fromList([
        0x3E, // packet ID
        0x0A, // operational state: 10 (0x0A) => Idle
        0x00, // workout verification: 0 => ?
        0x01, 0x00, // screen number: 1 => HOME SCREEN
        0x02, 0x00, // last error: 2 ?
        0x00, // calibration mode: 0
        0x00, // calibration state: 0
        0x00, // calibration status: 0
        0x01, // game id: 1 => Fish
        0x02, 0x00, // game score: 2
      ]);
      expect(data.lengthInBytes, equals(13));
      final status = parsePacket(data);
      final map = status!.asMap();
      expect(map[Keys.STATE_OPERATIONAL_STATE_KEY],
          equals(OperationalState.OPERATIONALSTATE_IDLE));
      expect(map[Keys.STATE_WORKOUT_VERIFICATION_KEY], equals(0));
      expect(map[Keys.STATE_SCREEN_NUMBER_KEY], equals(1));
      expect(map[Keys.STATE_LAST_ERROR_KEY], equals(2));
      expect(map[Keys.STATE_CALIBRATION_MODE_KEY], equals(0));
      expect(map[Keys.STATE_CALIBRATION_KEY], equals(0));
      expect(map[Keys.STATE_CALIBRATION_STATUS_KEY], equals(0));
      expect(map[Keys.STATE_GAME_ID_KEY], equals(GameId.FISH));
      expect(map[Keys.STATE_GAME_SCORE_KEY], equals(2));
    });
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
