import 'dart:typed_data';
import 'package:c2bluetooth/enums.dart';
import 'package:csafe_fitness/csafe_fitness.dart';
import 'keys.dart';
import './base.dart';

/// Represents a packet containing data for a "Segment" of a workout.
///
/// Segment refers to the concept of "split or interval" from Concept2's specification since the two are mutually exclusive.
///
/// Both segment data packets seem to start with the elapsed time have the [segmentNumber] stored at byte 18, so this class abstracts those two fields
class SharedSegmentData extends ElapsedtimeStampedData {
  int segmentNumber;
  SharedSegmentData.fromBytes(Uint8List data)
      : segmentNumber = data.elementAt(17),
        super.fromBytes(data);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({Keys.SEGMENT_NUMBER_KEY: segmentNumber});
    return map;
  }
}

/// Represents the first kind of [SegmentData] packet containing part of the full set of data about a segment of a workout
class SegmentData1 extends SharedSegmentData {
  double elapsedDistance;
  double segmentTime;
  int segmentDistance;
  int intervalRestTime;
  int intervalRestDistance;
  IntervalType segmentType;

  static Set<String> get datapointIdentifiers =>
      SegmentData1.zero().asMap().keys.toSet();

  SegmentData1.zero() : this.fromBytes(Uint8List(20));

  SegmentData1.fromBytes(Uint8List data)
      : elapsedDistance = CsafeIntExtension.fromBytes(data.sublist(3, 6),
                endian: Endian.little) /
            10,
        segmentTime = CsafeIntExtension.fromBytes(data.sublist(6, 9),
                endian: Endian.little) /
            10,
        segmentDistance = CsafeIntExtension.fromBytes(data.sublist(9, 12),
            endian: Endian.little),
        intervalRestTime = CsafeIntExtension.fromBytes(data.sublist(12, 14),
            endian: Endian.little),
        intervalRestDistance = CsafeIntExtension.fromBytes(data.sublist(14, 16),
            endian: Endian.little),
        segmentType = IntervalTypeExtension.fromInt(data.elementAt(16)),
        super.fromBytes(data);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.ELAPSED_DISTANCE_KEY: elapsedDistance,
      Keys.SEGMENT_TIME_KEY: segmentTime,
      Keys.SEGMENT_DISTANCE_KEY: segmentDistance,
      Keys.SEGMENT_TYPE_KEY: segmentType,
      Keys.SEGMENT_REST_TIME_KEY: intervalRestTime
    });
    return map;
  }
}

/// Represents the second kind of [SegmentData] packet containing the remaining part of the full set of data about a segment of a workout
class SegmentData2 extends SharedSegmentData {
  int segmentAvgStrokeRate;
  int segmentWorkHeartRate;
  int segmentRestHeartRate;
  double segmentAveragePace;
  int segmentTotalCalories;
  int segmentAverageCalories;
  double segmentSpeed;
  int segmentPower;
  int splitAverageDragFactor;
  MachineType machineType;

  static Set<String> get datapointIdentifiers =>
      SegmentData2.zero().asMap().keys.toSet();

  SegmentData2.zero() : this.fromBytes(Uint8List(20));

  SegmentData2.fromBytes(Uint8List data)
      : segmentAvgStrokeRate = data.elementAt(3),
        segmentWorkHeartRate = data.elementAt(4),
        segmentRestHeartRate = data.elementAt(5),
        segmentAveragePace = CsafeIntExtension.fromBytes(data.sublist(6, 8),
                endian: Endian.little) /
            10,
        segmentTotalCalories = CsafeIntExtension.fromBytes(data.sublist(8, 10),
            endian: Endian.little),
        segmentAverageCalories = CsafeIntExtension.fromBytes(
            data.sublist(10, 12),
            endian: Endian.little),
        segmentSpeed = CsafeIntExtension.fromBytes(data.sublist(12, 14),
                endian: Endian.little) /
            1000,
        segmentPower = CsafeIntExtension.fromBytes(data.sublist(14, 16),
            endian: Endian.little),
        splitAverageDragFactor = data.elementAt(16),
        machineType = MachineTypeExtension.fromInt(data.elementAt(18)),
        super.fromBytes(data);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({
      Keys.SEGMENT_AVG_SPM_KEY: segmentAvgStrokeRate,
      Keys.SEGMENT_WORK_HR_KEY: segmentWorkHeartRate,
      Keys.SEGMENT_REST_HR_KEY: segmentRestHeartRate,
      Keys.SEGMENT_AVG_PACE_KEY: segmentAveragePace,
      Keys.SEGMENT_CALORIES_KEY: segmentTotalCalories,
      Keys.SEGMENT_AVG_CALORIES_KEY: segmentAverageCalories,
      Keys.SEGMENT_SPEED_KEY: segmentSpeed,
      Keys.SEGMENT_POWER_KEY: segmentPower,
      Keys.SEGMENT_AVG_DRAGFACTOR_KEY: splitAverageDragFactor
    });
    return map;
  }
}
