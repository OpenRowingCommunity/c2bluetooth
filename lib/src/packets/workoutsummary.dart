import 'dart:typed_data';
import 'dart:async';

import 'package:c2bluetooth/extensions.dart';
import 'package:csafe_fitness/csafe_fitness.dart';

import 'package:c2bluetooth/helpers.dart';
import 'package:c2bluetooth/enums.dart';
import './base.dart';
import 'keys.dart';

/// Represents a summary of a completed workout from the multiplexed characteristic
///
/// The multiplexed characteristic is a slightly shorter packet since it emits packets representing multiple types of data. As a result it is prefixed with an extra byte as an identifier for what kind of data is in that packet. This prefix is removed prior to parsing the packet with this class.
///
/// This takes care of processesing the raw byte data from workout summary characteristics into easily accessible fields. This class also takes care of things like byte endianness, combining multiple high and low bytes .etc, allowing applications to access things in terms of flutter native types.
class WorkoutSummaryPacketMultiplexed extends TimestampedData {
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

  static Set<String> get datapointIdentifiers =>
      WorkoutSummaryPacketMultiplexed.zero().asMap().keys.toSet();

  /// Construct a WorkoutSummary from the bytes returned from the erg
  WorkoutSummaryPacketMultiplexed.fromBytes(Uint8List data)
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
        super.fromBytes(data);

  WorkoutSummaryPacketMultiplexed.zero() : this.fromBytes(Uint8List(20));

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.ELAPSED_TIME_KEY: elapsedTime,
      Keys.ELAPSED_DISTANCE_KEY: workDistance,
      Keys.WORKOUT_AVG_SPM_KEY: avgSPM,
      Keys.WORKOUT_LAST_HR_KEY: endHeartRate,
      Keys.WORKOUT_AVG_HR_KEY: avgHeartRate,
      Keys.WORKOUT_MIN_HR_KEY: minHeartRate,
      Keys.WORKOUT_MAX_HR_KEY: maxHeartRate,
      Keys.WORKOUT_AVG_DRAGFACTOR_KEY: avgDragFactor,
      Keys.WORKOUT_RECOVERY_HR_KEY: recoveryHeartRate,
    });
    return map;
  }
}

/// Represents a summary of a completed workout
///
/// This is the same as the multiplexed version of the packet, except it also has a data field for average pace, which the multiplexed packet doesnt have space for.
class WorkoutSummaryPacket extends WorkoutSummaryPacketMultiplexed {
  double avgPace;

  static Set<String> get datapointIdentifiers =>
      WorkoutSummaryPacketMultiplexed.zero().asMap().keys.toSet();

  /// Construct a WorkoutSummary from the bytes returned from the erg
  WorkoutSummaryPacket.fromBytes(Uint8List data)
      : avgPace = CsafeIntExtension.fromBytes(data.sublist(18),
                endian: Endian.little) /
            10,
        super.fromBytes(data);

  WorkoutSummaryPacket.zero() : this.fromBytes(Uint8List(20));

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.WORKOUT_AVG_PACE_KEY: avgPace,
    });
    return map;
  }
}

/// Represents the second packet containing additional summary information from a completed workout (from the multiplexed characteristic)
///
/// The multiplexed characteristic is a slightly shorter packet since it emits packets representing multiple types of data. As a result it is prefixed with an extra byte as an identifier for what kind of data is in that packet. This prefix is removed prior to parsing the packet with this class.
class WorkoutSummaryPacket2Multiplexed extends TimestampedData {
  int intervalSize;
  int intervalCount;
  int totalCalories;
  int watts;
  int totalRestDistance;
  int intervalRestTime;
  int avgCalories;

  static Set<String> get datapointIdentifiers =>
      WorkoutSummaryPacket2.zero().asMap().keys.toSet();

  WorkoutSummaryPacket2Multiplexed.fromBytes(Uint8List data)
      : intervalSize = CsafeIntExtension.fromBytes(data.sublist(4, 6),
            endian: Endian.little),
        intervalCount = data.elementAt(6),
        totalCalories = CsafeIntExtension.fromBytes(data.sublist(7, 9),
            endian: Endian.little),
        watts = CsafeIntExtension.fromBytes(data.sublist(9, 11),
            endian: Endian.little),
        totalRestDistance = CsafeIntExtension.fromBytes(data.sublist(11, 14),
            endian: Endian.little),
        intervalRestTime = CsafeIntExtension.fromBytes(data.sublist(14, 16),
            endian: Endian.little),
        avgCalories = CsafeIntExtension.fromBytes(data.sublist(16, 18),
            endian: Endian.little),
        super.fromBytes(data);

  WorkoutSummaryPacket2Multiplexed.zero() : this.fromBytes(Uint8List(19));

  Map<String, dynamic> asMap() {
    // workout.interval_rest_distance
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.WORKOUT_SEGMENT_COUNT_KEY: intervalSize,
      Keys.WORKOUT_SEGMENT_SIZE_KEY: intervalCount,
      Keys.WORKOUT_CALORIES_KEY: totalCalories,
      Keys.WORKOUT_WATTS_KEY: watts,
      Keys.WORKOUT_REST_DISTANCE_KEY: totalRestDistance,
      // "workout.interval_rest_distance": ,
      Keys.WORKOUT_REST_TIME_KEY: intervalRestTime,
      Keys.WORKOUT_AVG_CALORIES_KEY: avgCalories
    });
    return map;
  }
}

/// Represents the second packet containing additional summary information from a completed workout
///
/// This is almost the same as the multiplexed version, except it contains the [intervalType] value. Because this value is near the beginning, its removal in the multiplexed version causes all the indices of the remaining data to be shifted, necessitating a new, mostly similar class.
class WorkoutSummaryPacket2 extends TimestampedData {
  IntervalType intervalType;
  int intervalSize;
  int intervalCount;
  int totalCalories;
  int watts;
  int totalRestDistance;
  int intervalRestTime;
  int avgCalories;

  static Set<String> get datapointIdentifiers =>
      WorkoutSummaryPacket2.zero().asMap().keys.toSet();

  WorkoutSummaryPacket2.fromBytes(Uint8List data)
      : intervalType = IntervalTypeExtension.fromInt(data.elementAt(4)),
        intervalSize = CsafeIntExtension.fromBytes(data.sublist(5, 7),
            endian: Endian.little),
        intervalCount = data.elementAt(7),
        totalCalories = CsafeIntExtension.fromBytes(data.sublist(8, 10),
            endian: Endian.little),
        watts = CsafeIntExtension.fromBytes(data.sublist(10, 12),
            endian: Endian.little),
        totalRestDistance = CsafeIntExtension.fromBytes(data.sublist(12, 15),
            endian: Endian.little),
        intervalRestTime = CsafeIntExtension.fromBytes(data.sublist(15, 17),
            endian: Endian.little),
        avgCalories = CsafeIntExtension.fromBytes(data.sublist(17, 19),
            endian: Endian.little),
        super.fromBytes(data);

  WorkoutSummaryPacket2.zero() : this.fromBytes(Uint8List(19));

  Map<String, dynamic> asMap() {
    // workout.heart_rate
    // workout.interval_rest_distance
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      //intervalType
      Keys.WORKOUT_SEGMENT_COUNT_KEY: intervalSize,
      Keys.WORKOUT_SEGMENT_SIZE_KEY: intervalCount,
      Keys.WORKOUT_CALORIES_KEY: totalCalories,
      Keys.WORKOUT_WATTS_KEY: watts,
      Keys.WORKOUT_REST_DISTANCE_KEY: totalRestDistance,
      // "workout.interval_rest_distance": ,
      Keys.WORKOUT_REST_TIME_KEY: intervalRestTime,
      Keys.WORKOUT_AVG_CALORIES_KEY: avgCalories
    });
    return map;
  }
}

/// Represents the third packet containing additional summary information from a completed workout (from the multiplexed characteristic)
///
/// The multiplexed characteristic has a third workout summary packet because the other two are shorter to account for the packet type identification byte. As a result a third packet is needed to convey all the data
class WorkoutSummaryPacket3Multiplexed extends TimestampedData {
  double avgPace;
  // GameType gameType;
  bool workoutVerifiedFlag;
  int gameScore;
  MachineType machineType;

  static Set<String> get datapointIdentifiers =>
      WorkoutSummaryPacket2.zero().asMap().keys.toSet();

  WorkoutSummaryPacket3Multiplexed.fromBytes(Uint8List data)
      : avgPace = CsafeIntExtension.fromBytes(data.sublist(4, 6),
                endian: Endian.little) /
            10,
        // gameType = GameTypeExtension.fromInt(data.elementAt(6) & 0x0F),
        workoutVerifiedFlag = (data.elementAt(6) & 0x0F) >> 4 == 1,
        gameScore = CsafeIntExtension.fromBytes(data.sublist(7, 9),
            endian: Endian.little),
        machineType = MachineTypeExtension.fromInt(data.elementAt(9)),
        super.fromBytes(data);

  WorkoutSummaryPacket3Multiplexed.zero() : this.fromBytes(Uint8List(19));

  Map<String, dynamic> asMap() {
    // workout.interval_rest_distance
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      // Keys.WORKOUT_SEGMENT_COUNT_KEY: intervalSize,
      // Keys.WORKOUT_SEGMENT_SIZE_KEY: intervalCount,
      // Keys.WORKOUT_CALORIES_KEY: totalCalories,
      // Keys.WORKOUT_WATTS_KEY: watts,
      // Keys.WORKOUT_REST_DISTANCE_KEY: totalRestDistance,
      // // "workout.interval_rest_distance": ,
      // Keys.WORKOUT_REST_TIME_KEY: intervalRestTime,
      // Keys.WORKOUT_AVG_CALORIES_KEY: avgCalories
    });
    return map;
  }
}
