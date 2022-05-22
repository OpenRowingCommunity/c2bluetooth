import 'dart:typed_data';
import 'package:csafe_fitness/csafe_fitness.dart';

import './base.dart';

/// Represents a packet containing data for a "Segment" of a workout.
///
/// Segment refers to the concept of "split or interval" from Concept2's specification since the two are mutually exclusive
class SegmentData extends ElapsedtimeStampedData {
  double distance;
  // double segmentTime;
  int segmentDistance;
  int segmentRestTime;
  int segmentRestDistance;
  int segmentNumber;

  SegmentData.fromBytes(Uint8List data)
      : distance = CsafeIntExtension.fromBytes(data.sublist(3, 6),
                endian: Endian.little) /
            10,
        // segmentTime = 6,9,
        segmentDistance = CsafeIntExtension.fromBytes(data.sublist(9, 12),
            endian: Endian.little),
        segmentRestDistance = CsafeIntExtension.fromBytes(data.sublist(12, 14),
            endian: Endian.little),
        segmentRestTime = CsafeIntExtension.fromBytes(data.sublist(14, 16),
            endian: Endian.little),
        segmentNumber = data.elementAt(18),
        super.fromBytes(data);
}

/// Represents a packet containing data for a "Segment" of a workout.
///
/// Segment refers to the concept of "split or interval" from Concept2's specification since the two are mutually exclusive
class SegmentData2 extends ElapsedtimeStampedData {
  SegmentData2.fromBytes(Uint8List data) : super.fromBytes(data);
}
