import 'dart:typed_data';
import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:csafe_fitness/csafe_fitness.dart';

import './base.dart';

class StatusData extends ElapsedtimeStampedData {
  final double distance; // 0x01 = 0.1 meters
  final WorkoutType workoutType;
  final IntervalType intervalType;
  final WorkoutState workoutState;
  final RowingState rowingState;
  final StrokeState strokeState;
  final int totalWorkDistance; // meters
  final double workoutDuration; // FIXME: Can also be Duration
  final DurationType durationType;
  final int dragFactor;

  static Set<String> get datapointIdentifiers =>
      StatusData.zero().asMap().keys.toSet();

  StatusData.zero() : this.fromBytes(Uint8List(19));

  StatusData.fromBytes(Uint8List data)
      : distance = CsafeIntExtension.fromBytes(data.sublist(3, 6),
                endian: Endian.little) /
            10.0,
        workoutType = WorkoutTypeExtension.fromInt(data[6]),
        intervalType = IntervalTypeExtension.fromInt(data[7]),
        workoutState = WorkoutStateExtension.fromInt(data[8]),
        rowingState = RowingStateExtension.fromInt(data[9]),
        strokeState = StrokeStateExtension.fromInt(data[10]),
        totalWorkDistance = CsafeIntExtension.fromBytes(data.sublist(11, 14),
            endian: Endian.little),
        durationType = DurationTypeExtension.fromInt(data[17]),
        workoutDuration = CsafeIntExtension.fromBytes(data.sublist(14, 17),
                endian: Endian.little) /
            (DurationTypeExtension.fromInt(data[17]) == DurationType.TIME
                ? 100.0
                : 1),
        dragFactor = data[18],
        super.fromBytes(data);

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.ELAPSED_DISTANCE_KEY: distance,
      Keys.STATE_WORKOUT_TYPE_KEY: workoutType,
      Keys.STATE_SEGMENT_TYPE_KEY: intervalType,
      Keys.STATE_WORKOUT_KEY: workoutState,
      Keys.STATE_ROWING_KEY: rowingState,
      Keys.STATE_ROWING_STROKE_KEY: strokeState,
      Keys.WORKOUT_TOTAL_DISTANCE_KEY: totalWorkDistance,
      Keys.WORKOUT_DURATION_KEY: workoutDuration,
      Keys.WORKOUT_DURATION_UNIT_KEY: durationType,
      Keys.WORKOUT_DRAG_FACTOR_KEY: dragFactor,
    });
    return map;
  }
}

class StatusData1 extends ElapsedtimeStampedData {
  final double speed; // 0x01 = 0.001 m/s
  final int strokeRate; // strokes/min
  final int heartRate; // bpm, 255=invalid
  final Duration currentPace; // 0x01 = 0.01 sec per 500m
  final Duration averagePace; // 0x01 = 0.01 sec per 500m
  final int restDistance; // meters
  final Duration restTime; // 0x01 = 0.01 seconds
  final int averagePower; // watts
  final MachineType ergMachineType;

  static Set<String> get datapointIdentifiers =>
      StatusData1.zero().asMap().keys.toSet();

  StatusData1.zero() : this.fromBytes(Uint8List(19));

  StatusData1.fromBytes(Uint8List data)
      : speed = CsafeIntExtension.fromBytes(data.sublist(3, 5),
                endian: Endian.little) /
            1000.0,
        strokeRate = data[5],
        heartRate = data[6],
        currentPace = Duration(
            milliseconds: CsafeIntExtension.fromBytes(data.sublist(7, 9),
                    endian: Endian.little) *
                10),
        averagePace = Duration(
            milliseconds: CsafeIntExtension.fromBytes(data.sublist(9, 11),
                    endian: Endian.little) *
                10),
        restDistance = CsafeIntExtension.fromBytes(data.sublist(11, 13),
            endian: Endian.little),
        restTime = Duration(
            milliseconds: CsafeIntExtension.fromBytes(data.sublist(13, 16),
                    endian: Endian.little) *
                10),
        averagePower = CsafeIntExtension.fromBytes(data.sublist(16, 18),
            endian: Endian.little),
        ergMachineType = MachineTypeExtension.fromInt(data[18]),
        super.fromBytes(data);

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.WORKOUT_SPEED_KEY: speed,
      Keys.WORKOUT_SPM_KEY: strokeRate,
      Keys.WORKOUT_HR_KEY: heartRate,
      Keys.WORKOUT_PACE_KEY: currentPace,
      Keys.WORKOUT_AVG_PACE_KEY: averagePace,
      Keys.WORKOUT_REST_DISTANCE_KEY: restDistance,
      Keys.WORKOUT_REST_TIME_KEY: restTime,
      Keys.WORKOUT_AVG_POWER_KEY: averagePower,
      Keys.WORKOUT_MACHINE_TYPE_KEY: ergMachineType,
    });
    return map;
  }
}

class StatusData2 extends ElapsedtimeStampedData {
  final int intervalCount;
  final int totalCalories; // cals
  final Duration splitAvgPace; // 0x01 = 0.01 sec per 500m
  final int splitAvgPower; // watts
  final int splitAvgCalories; // cals
  final Duration lastSplitTime; // 0x01 = 0.1 seconds
  final int lastSplitDistance; // meters

  static Set<String> get datapointIdentifiers =>
      StatusData2.zero().asMap().keys.toSet();

  StatusData2.zero() : this.fromBytes(Uint8List(20));

  StatusData2.fromBytes(Uint8List data)
      : intervalCount = data[3],
        totalCalories = CsafeIntExtension.fromBytes(data.sublist(4, 6),
            endian: Endian.little),
        splitAvgPace = Duration(
            milliseconds: CsafeIntExtension.fromBytes(data.sublist(6, 8),
                    endian: Endian.little) *
                10),
        splitAvgPower = CsafeIntExtension.fromBytes(data.sublist(8, 10),
            endian: Endian.little),
        splitAvgCalories = CsafeIntExtension.fromBytes(data.sublist(10, 12),
            endian: Endian.little),
        lastSplitTime = Duration(
            milliseconds: CsafeIntExtension.fromBytes(data.sublist(12, 15),
                    endian: Endian.little) *
                100),
        lastSplitDistance = CsafeIntExtension.fromBytes(data.sublist(15, 17),
            endian: Endian.little),
        super.fromBytes(data);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.SEGMENT_NUMBER_KEY: intervalCount,
      Keys.WORKOUT_CALORIES_KEY: totalCalories,
      Keys.SEGMENT_AVG_PACE_KEY: splitAvgPace,
      Keys.SEGMENT_AVG_POWER_KEY: splitAvgPower,
      Keys.SEGMENT_AVG_CALORIES_KEY: splitAvgCalories,
      Keys.SEGMENT_LAST_TIME_KEY: lastSplitTime,
      Keys.SEGMENT_LAST_DISTANCE_KEY: lastSplitDistance,
    });
    return map;
  }
}

class StatusData3 extends Concept2CharacteristicData {
  final OperationalState operationalState;
  final int workoutVerificationState;
  final int screenNumber;
  final int lastError;
  final int calibrationMode;
  final int calibrationState;
  final int calibrationStatus;
  final GameId gameID;
  final int gameScore;

  static Set<String> get datapointIdentifiers =>
      StatusData2.zero().asMap().keys.toSet();

  StatusData3.zero() : this.fromBytes(Uint8List(20));

  StatusData3.fromBytes(Uint8List data)
      : operationalState = OperationalStateExtension.fromInt(data[0]),
        workoutVerificationState = data[1],
        screenNumber = CsafeIntExtension.fromBytes(data.sublist(2, 4),
            endian: Endian.little),
        lastError = CsafeIntExtension.fromBytes(data.sublist(4, 6),
            endian: Endian.little),
        calibrationMode = data[6],
        calibrationState = data[7],
        calibrationStatus = data[8],
        gameID = GameIdExtension.fromInt(data[9]),
        gameScore = CsafeIntExtension.fromBytes(data.sublist(10, 12),
            endian: Endian.little);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.STATE_OPERATIONAL_STATE_KEY: operationalState,
      Keys.STATE_WORKOUT_VERIFICATION_KEY: workoutVerificationState,
      Keys.STATE_SCREEN_NUMBER_KEY: screenNumber,
      Keys.STATE_LAST_ERROR_KEY: lastError,
      Keys.STATE_CALIBRATION_MODE_KEY: calibrationMode,
      Keys.STATE_CALIBRATION_KEY: calibrationState,
      Keys.STATE_CALIBRATION_STATUS_KEY: calibrationStatus,
      Keys.STATE_GAME_ID_KEY: gameID,
      Keys.STATE_GAME_SCORE_KEY: gameScore,
    });
    return map;
  }
}
