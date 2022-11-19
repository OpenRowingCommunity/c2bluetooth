import 'dart:typed_data';
import 'package:c2bluetooth/enums.dart';
import 'package:c2bluetooth/extensions.dart';
import 'package:csafe_fitness/csafe_fitness.dart';

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
}

/// Represents the first kind of [SegmentData] packet containing part of the full set of data about a segment of a workout
class SegmentData1 extends SharedSegmentData {
  double elapsedDistance;
  double segmentTime;
  int segmentDistance;
  int intervalRestTime;
  int intervalRestDistance;
  IntervalType segmentType;

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
}
