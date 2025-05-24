import 'dart:typed_data';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:csafe_fitness/csafe_fitness.dart';

import './base.dart';

class StrokeData extends ElapsedtimeStampedData {
  static Set<String> get datapointIdentifiers =>
      StrokeData.zero().asMap().keys.toSet();
  final double distance; // 0x01 =  0.1 meters
  final double driveLength; // 0x01 = 0.01 meters, max = 2.55m
  final Duration driveTime; // 0x01 = 0.01 sec, max = 2.55 sec
  final Duration recoveryTime; // 0x01 = 0.01 sec, max = 655.35 sec
  final double strokeDistance; // 0x01 = 0.01 m, max=655.35m
  final double peakForce; // 0x01 = 0.1 lbs of force, max=655.35 lbs
  final double averageForce; // 0x01 = 0.1 lbs of force, max=655.35 lbs
  final int strokeCount;

  StrokeData.zero() : this.fromBytes(Uint8List(20));

  StrokeData.fromBytes(Uint8List data)
      : distance = CsafeIntExtension.fromBytes(data.sublist(3, 6),
                endian: Endian.little) /
            10.0,
        driveLength = data[6] / 100.0,
        driveTime = Duration(
            seconds: data[7] ~/ 100, milliseconds: data[7].remainder(100)),
        recoveryTime = Duration(
            milliseconds: CsafeIntExtension.fromBytes(data.sublist(8, 10),
                    endian: Endian.little) *
                10),
        strokeDistance = CsafeIntExtension.fromBytes(data.sublist(10, 12),
                endian: Endian.little) /
            10.0,
        peakForce = CsafeIntExtension.fromBytes(data.sublist(12, 14),
                endian: Endian.little) /
            10.0,
        averageForce = CsafeIntExtension.fromBytes(data.sublist(14, 16),
                endian: Endian.little) /
            10.0,
        strokeCount = CsafeIntExtension.fromBytes(data.sublist(16, 18),
            endian: Endian.little),
        super.fromBytes(data);

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.ELAPSED_DISTANCE_KEY: distance,
      Keys.STROKE_DRIVE_LENGTH_KEY: driveLength,
      Keys.STROKE_DRIVE_TIME_KEY: driveTime,
      Keys.STROKE_RECOVERY_TIME_KEY: recoveryTime,
      Keys.STROKE_DISTANCE_KEY: strokeDistance,
      Keys.STROKE_PEAK_FORCE_KEY: peakForce,
      Keys.STROKE_AVG_FORCE_KEY: averageForce,
      Keys.STROKE_COUNT_KEY: strokeCount,
    });

    return map;
  }
}

/// Additional stroke data from characteristic 0x0036
class StrokeData2 extends ElapsedtimeStampedData {
  static Set<String> get datapointIdentifiers =>
      StrokeData2.zero().asMap().keys.toSet();
  final int strokePower; // watts
  final int strokeCalories; // cals/hr
  final int strokeCount;
  final Duration projectedWorkTime; // secs
  final int projectedWorkDistance; // meters
  final double workPerStroke; // 0x01 = 0.1 Joules, max=6553.5 Joules

  StrokeData2.zero() : this.fromBytes(Uint8List(20));

  StrokeData2.fromBytes(Uint8List data)
      : strokePower = CsafeIntExtension.fromBytes(data.sublist(3, 5),
            endian: Endian.little),
        strokeCalories = CsafeIntExtension.fromBytes(data.sublist(5, 7),
            endian: Endian.little),
        strokeCount = CsafeIntExtension.fromBytes(data.sublist(7, 9),
            endian: Endian.little),
        projectedWorkTime = Duration(
            seconds: CsafeIntExtension.fromBytes(data.sublist(9, 12),
                endian: Endian.little)),
        projectedWorkDistance = CsafeIntExtension.fromBytes(
            data.sublist(12, 15),
            endian: Endian.little),
        workPerStroke = CsafeIntExtension.fromBytes(data.sublist(15, 17),
                endian: Endian.little) /
            10.0,
        super.fromBytes(data);

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.WORKOUT_POWER_KEY: strokePower,
      Keys.WORKOUT_CALORIES_KEY: strokeCalories,
      Keys.STROKE_COUNT_KEY: strokeCount,
      Keys.WORKOUT_PROJECTED_TIME_KEY: projectedWorkTime,
      Keys.WORKOUT_PROJECTED_DISTANCE_KEY: projectedWorkDistance,
      Keys.STROKE_ENERGY_KEY: workPerStroke,
    });
    return map;
  }
}
