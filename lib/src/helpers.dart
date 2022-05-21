import 'dart:typed_data';

import './packets/statusdata.dart';
import './packets/strokedata.dart';
import './packets/segmentdata.dart';
import './packets/workoutsummary.dart';
import './packets/forcecurvepacket.dart';

import './packets/base.dart';

Concept2CharacteristicData? parsePacket(Uint8List data) {
  switch (data[0]) {
    case 0x31:
      StatusData parsed = StatusData.fromBytes(data.sublist(1));
      print(parsed.elapsedTime.toString());
      print("distance ${parsed.distance.toString()}");

      return parsed;
    case 0x32:
      StatusData1 parsed = StatusData1.fromBytes(data.sublist(1));
      print(parsed.elapsedTime.toString());
      print("speed ${parsed.speed.toString()}");

      return parsed;
    case 0x33:
      StatusData2 parsed = StatusData2.fromBytes(data.sublist(1));
      print(parsed.elapsedTime.toString());
      // print("intervalcount ${parsed.intervalCount.toString()}");
      return parsed;
    case 0x35:
      return StrokeData.fromBytes(data.sublist(1));
    case 0x36:
      return StrokeData2.fromBytes(data.sublist(1));
    case 0x37:
      return SegmentData.fromBytes(data.sublist(1));
    case 0x38:
      return SegmentData2.fromBytes(data.sublist(1));
    case 0x39:
      return WorkoutSummaryPacket.fromBytes(data.sublist(1));
    case 0x3A:
      return WorkoutSummaryPacket2.fromBytes(data.sublist(1));
    case 0x3C:
      return ForceCurveData.fromBytes(data.sublist(1));
    default:
      return null;
  }
}
