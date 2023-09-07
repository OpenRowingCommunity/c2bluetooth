import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

import './base.dart';
import 'keys.dart';

class StrokeData extends ElapsedtimeStampedData {
  double totalDistance;
  double strokeDistance;

  double driveLength;
  double driveTime;
  double recoveryTime;

  double peakDriveForce;
  double avgDriveForce;
  double workPerStroke;
  int strokeCount;

  static Set<String> get datapointIdentifiers =>
      StrokeData.zero().asMap().keys.toSet();

  StrokeData.zero() : this.fromBytes(Uint8List(20));

  StrokeData.fromBytes(Uint8List data)
      : totalDistance = CsafeIntExtension.fromBytes(data.sublist(3, 6),
                endian: Endian.little) /
            10,
        driveLength = CsafeIntExtension.fromBytes(data.sublist(6, 7),
                endian: Endian.little) /
            100,
        driveTime = CsafeIntExtension.fromBytes(data.sublist(7, 8),
                endian: Endian.little) /
            100,
        recoveryTime = CsafeIntExtension.fromBytes(data.sublist(8, 10),
                endian: Endian.little) /
            100,
        strokeDistance = CsafeIntExtension.fromBytes(data.sublist(10, 12),
                endian: Endian.little) /
            100,
        peakDriveForce = CsafeIntExtension.fromBytes(data.sublist(12, 14),
                endian: Endian.little) /
            10,
        avgDriveForce = CsafeIntExtension.fromBytes(data.sublist(14, 16),
                endian: Endian.little) /
            10,
        workPerStroke = CsafeIntExtension.fromBytes(data.sublist(16, 18),
                endian: Endian.little) /
            10,
        strokeCount = CsafeIntExtension.fromBytes(data.sublist(18, 20)),
        super.fromBytes(data);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.ELAPSED_DISTANCE_KEY: totalDistance,
      Keys.STROKE_DISTANCE_KEY: strokeDistance,
      Keys.STROKE_DRIVE_LENGTH_KEY: driveLength,
      Keys.STROKE_DRIVE_TIME_KEY: driveTime,
      Keys.STROKE_RECOVERY_TIME_KEY: recoveryTime,
      // Keys.stroke : peakDriveForce
      Keys.STROKE_AVERAGE_DRIVE_FORCE_KEY: avgDriveForce,
      // Keys.STROKE_POWER_KEY: workPerStroke,
      Keys.STROKE_NUMBER_KEY: strokeCount
    });
    return map;
  }
}

class StrokeData2 extends ElapsedtimeStampedData {
  int strokePower;
  int strokeCalories;
  int projectedWorkTime;
  int projectedWorkDistance;
  int strokeCount;

  static Set<String> get datapointIdentifiers =>
      StrokeData2.zero().asMap().keys.toSet();

  StrokeData2.zero() : this.fromBytes(Uint8List(20));

  StrokeData2.fromBytes(Uint8List data)
      : strokePower = CsafeIntExtension.fromBytes(data.sublist(3, 5),
            endian: Endian.little),
        strokeCalories = CsafeIntExtension.fromBytes(data.sublist(5, 7),
            endian: Endian.little),
        strokeCount = CsafeIntExtension.fromBytes(data.sublist(7, 9)),
        projectedWorkTime = CsafeIntExtension.fromBytes(data.sublist(9, 12)),
        projectedWorkDistance =
            CsafeIntExtension.fromBytes(data.sublist(12, 15)),
        super.fromBytes(data);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.STROKE_POWER_KEY: strokePower,
      Keys.STROKE_CALORIES_KEY: strokeCalories,
      // Keys. : projectedWorkTime,
      // Keys. : projectedWorkDistance,
      Keys.STROKE_NUMBER_KEY: strokeCount
    });
    return map;
  }
}

class StrokeDataMultiplexed extends ElapsedtimeStampedData {
  double totalDistance;
  double strokeDistance;

  double driveLength;
  double driveTime;
  double recoveryTime;

  double peakDriveForce;
  double avgDriveForce;
  int strokeCount;

  static Set<String> get datapointIdentifiers =>
      StrokeDataMultiplexed.zero().asMap().keys.toSet();

  StrokeDataMultiplexed.zero() : this.fromBytes(Uint8List(20));

  StrokeDataMultiplexed.fromBytes(Uint8List data)
      : totalDistance = CsafeIntExtension.fromBytes(data.sublist(3, 6),
                endian: Endian.little) /
            10,
        driveLength = CsafeIntExtension.fromBytes(data.sublist(6, 7),
                endian: Endian.little) /
            100,
        driveTime = CsafeIntExtension.fromBytes(data.sublist(7, 8),
                endian: Endian.little) /
            100,
        recoveryTime = CsafeIntExtension.fromBytes(data.sublist(8, 10),
                endian: Endian.little) /
            100,
        strokeDistance = CsafeIntExtension.fromBytes(data.sublist(10, 12),
                endian: Endian.little) /
            100,
        peakDriveForce = CsafeIntExtension.fromBytes(data.sublist(12, 14),
                endian: Endian.little) /
            10,
        avgDriveForce = CsafeIntExtension.fromBytes(data.sublist(14, 16),
                endian: Endian.little) /
            10,
        strokeCount = CsafeIntExtension.fromBytes(data.sublist(16, 18)),
        super.fromBytes(data);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.ELAPSED_DISTANCE_KEY: totalDistance,
      Keys.STROKE_DISTANCE_KEY: strokeDistance,
      Keys.STROKE_DRIVE_LENGTH_KEY: driveLength,
      Keys.STROKE_DRIVE_TIME_KEY: driveTime,
      Keys.STROKE_RECOVERY_TIME_KEY: recoveryTime,
      // Keys.stroke : peakDriveForce
      Keys.STROKE_AVERAGE_DRIVE_FORCE_KEY: avgDriveForce,
      Keys.STROKE_NUMBER_KEY: strokeCount
    });
    return map;
  }
}

class StrokeDataMultiplexed2 extends ElapsedtimeStampedData {
  int strokePower;
  int strokeCalories;
  int projectedWorkTime;
  int projectedWorkDistance;
  int strokeCount;
  double workPerStroke;

  static Set<String> get datapointIdentifiers =>
      StrokeDataMultiplexed2.zero().asMap().keys.toSet();

  StrokeDataMultiplexed2.zero() : this.fromBytes(Uint8List(20));

  StrokeDataMultiplexed2.fromBytes(Uint8List data)
      : strokePower = CsafeIntExtension.fromBytes(data.sublist(3, 5),
            endian: Endian.little),
        strokeCalories = CsafeIntExtension.fromBytes(data.sublist(5, 7),
            endian: Endian.little),
        strokeCount = CsafeIntExtension.fromBytes(data.sublist(7, 9)),
        projectedWorkTime = CsafeIntExtension.fromBytes(data.sublist(9, 12)),
        projectedWorkDistance =
            CsafeIntExtension.fromBytes(data.sublist(12, 15)),
        workPerStroke = CsafeIntExtension.fromBytes(data.sublist(16, 18),
                endian: Endian.little) /
            10,
        super.fromBytes(data);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.STROKE_POWER_KEY: strokePower,
      Keys.STROKE_CALORIES_KEY: strokeCalories,
      // Keys. : projectedWorkTime,
      // Keys. : projectedWorkDistance,
      Keys.STROKE_NUMBER_KEY: strokeCount
      // Keys.: workPerStroke,
    });
    return map;
  }
}
