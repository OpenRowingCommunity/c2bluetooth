import 'dart:typed_data';

import 'package:c2bluetooth/extensions.dart';
import 'package:csafe_fitness/csafe_fitness.dart';

import 'package:c2bluetooth/enums.dart';
import './base.dart';
import 'keys.dart';

/// Represents a summary of a completed workout
///
/// This takes care of processesing the raw byte data from workout summary characteristics into easily accessible fields. This class also takes care of things like byte endianness, combining multiple high and low bytes .etc, allowing applications to access things in terms of flutter native types.
class WorkoutSummaryPacket extends TimestampedData {
  Duration elapsedTime;
  double workDistance;
  int avgSPM;
  int endHeartRate;
  int avgHeartRate;
  int minHeartRate;
  int maxHeartRate;
  int avgDragFactor;
  int recoveryHeartRate;
  WorkoutType workoutType;
  double avgPace;

  static Set<String> get datapointIdentifiers =>
      WorkoutSummaryPacket.zero().asMap().keys.toSet();

  /// Construct a WorkoutSummary from the bytes returned from the erg
  WorkoutSummaryPacket.fromBytes(Uint8List data)
      : elapsedTime = Concept2DurationExtension.fromBytes(data.sublist(4, 7)),
        workDistance = CsafeIntExtension.fromBytes(data.sublist(7, 10),
                endian: Endian.little) /
            10,
        avgSPM = data.elementAt(10),
        endHeartRate = data.elementAt(11),
        avgHeartRate = data.elementAt(12),
        minHeartRate = data.elementAt(13),
        maxHeartRate = data.elementAt(14),
        avgDragFactor = data.elementAt(15),
        recoveryHeartRate = data.elementAt(16),
        workoutType = WorkoutTypeExtension.fromInt(data.elementAt(17)),
        avgPace = CsafeIntExtension.fromBytes(data.sublist(18),
                endian: Endian.little) /
            10,
        super.fromBytes(data);

  WorkoutSummaryPacket.zero() : this.fromBytes(Uint8List(20));

  Map<String, dynamic> asMap() {
    //     workout.date
    // workout.time

    // workout.heart_rate
    // workout.spl-int_count
    // workout.spl-int_size
    // workout.calories
    // workout.watts
    // workout.rest_distance
    // workout.interval_rest_distance
    // workout.rest_time
    // workout.calories.average
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.ELAPSED_TIME_KEY: elapsedTime,
      Keys.WORKOUT_DISTANCE_KEY: workDistance,
      Keys.WORKOUT_AVG_SPM_KEY: avgSPM,
      Keys.WORKOUT_LAST_HR_KEY: endHeartRate,
      Keys.WORKOUT_AVG_HR_KEY: avgHeartRate,
      Keys.WORKOUT_MIN_HR_KEY: minHeartRate,
      Keys.WORKOUT_MAX_HR_KEY: maxHeartRate,
      Keys.WORKOUT_AVG_PACE_KEY: avgPace,
      Keys.WORKOUT_AVG_DRAGFACTOR_KEY: avgDragFactor,
      Keys.WORKOUT_RECOVERY_HR_KEY: recoveryHeartRate,
      // workoutType,
      // "something.something.average":
    });
    return map;
  }
}

class WorkoutSummaryPacket1 extends TimestampedData {
  int intervalSize;
  int intervalCount;
  int totalCalories;
  int watts;
  int totalRestDistance;
  int intervalRestTime;
  int avgCalories;

  static Set<String> get datapointIdentifiers =>
      WorkoutSummaryPacket1.zero().asMap().keys.toSet();

  WorkoutSummaryPacket1.fromBytes(Uint8List data)
      : intervalSize = CsafeIntExtension.fromBytes(data.sublist(4, 6),
            endian: Endian.little),
        intervalCount = data.elementAt(6),
        totalCalories = CsafeIntExtension.fromBytes(data.sublist(7, 9),
            endian: Endian.little),
        watts = CsafeIntExtension.fromBytes(data.sublist(9, 11),
            endian: Endian.little),
        totalRestDistance = CsafeIntExtension.fromBytes(data.sublist(11, 13),
            endian: Endian.little),
        intervalRestTime = CsafeIntExtension.fromBytes(data.sublist(13, 16),
            endian: Endian.little),
        avgCalories = CsafeIntExtension.fromBytes(data.sublist(16, 18),
            endian: Endian.little),
        super.fromBytes(data);

  WorkoutSummaryPacket1.zero() : this.fromBytes(Uint8List(18));

  Map<String, dynamic> asMap() {
    // workout.heart_rate
    // workout.interval_rest_distance
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.WORKOUT_SEGMENT_COUNT_KEY: intervalSize,
      Keys.WORKOUT_SEGMENT_SIZE_KEY: intervalCount,
      Keys.WORKOUT_CALORIES_KEY: totalCalories,
      Keys.WORKOUT_POWER_KEY: watts,
      Keys.WORKOUT_REST_DISTANCE_KEY: totalRestDistance,
      // "workout.interval_rest_distance": ,
      Keys.WORKOUT_REST_TIME_KEY: intervalRestTime,
      Keys.WORKOUT_AVG_CALORIES_KEY: avgCalories
    });
    return map;
  }
}

class WorkoutSummaryPacket2 extends TimestampedData {
  int avgPace;
  GameId gameID;
  int verifier;
  int gameScore;
  MachineType machineType;

  static Set<String> get datapointIdentifiers =>
      WorkoutSummaryPacket2.zero().asMap().keys.toSet();

  WorkoutSummaryPacket2.zero() : this.fromBytes(Uint8List(10));

  WorkoutSummaryPacket2.fromBytes(Uint8List data)
      : avgPace = CsafeIntExtension.fromBytes(data.sublist(4, 6),
            endian: Endian.little),
        gameID = GameIdExtension.fromInt(data.elementAt(6) & 0x0F),
        verifier = (data.elementAt(6) & 0xF0) >> 4,
        gameScore = CsafeIntExtension.fromBytes(data.sublist(7, 9),
            endian: Endian.little),
        machineType = MachineTypeExtension.fromInt(data.elementAt(9)),
        super.fromBytes(data);

  Map<String, dynamic> asMap() {
    // workout.heart_rate
    // workout.interval_rest_distance
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.SUMMARY_AVG_PACE_KEY: avgPace,
      Keys.STATE_GAME_ID_KEY: gameID,
      Keys.STATE_WORKOUT_VERIFICATION_KEY: verifier,
      // "workout.interval_rest_distance": ,
      Keys.STATE_GAME_SCORE_KEY: gameScore,
      Keys.WORKOUT_MACHINE_TYPE_KEY: machineType
    });
    return map;
  }
}
