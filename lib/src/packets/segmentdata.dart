import 'dart:typed_data';
import 'package:csafe_fitness/csafe_fitness.dart';

import './base.dart';

/// Represents a packet containing data for a "Segment" of a workout.
///
/// Segment refers to the concept of "split or interval" from Concept2's specification since the two are mutually exclusive
class SegmentData extends ElapsedtimeStampedData {
  SegmentData.fromBytes(Uint8List data) : super.fromBytes(data);
}

/// Represents a packet containing data for a "Segment" of a workout.
///
/// Segment refers to the concept of "split or interval" from Concept2's specification since the two are mutually exclusive
class SegmentData2 extends ElapsedtimeStampedData {
  SegmentData2.fromBytes(Uint8List data) : super.fromBytes(data);
}
