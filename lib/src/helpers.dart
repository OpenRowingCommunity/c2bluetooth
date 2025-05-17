import 'package:flutter/foundation.dart';

import './packets/statusdata.dart';
import './packets/strokedata.dart';
import './packets/segmentdata.dart';
import './packets/workoutsummary.dart';
import './packets/forcecurvepacket.dart';
import './packets/belt.dart';

import './packets/base.dart';

/// Simplify mocking on [Dataplex]
typedef ParsePacketFn = Concept2CharacteristicData? Function(Uint8List);

// Allow mapping functions
typedef PacketParser = Concept2CharacteristicData Function(Uint8List data);

/// Mapping of the first byte of the multiplexed packet to its parser function.
final Map<int, PacketParser> _packetParsers = {
  0x31: (data) => StatusData.fromBytes(data),
  0x32: (data) => StatusData1.fromBytes(data),
  0x33: (data) => StatusData2.fromBytes(data),
  0x35: (data) => StrokeData.fromBytes(data),
  0x36: (data) => StrokeData2.fromBytes(data),
  0x37: (data) => SegmentData1.fromBytes(data),
  0x38: (data) => SegmentData2.fromBytes(data),
  0x39: (data) => WorkoutSummaryPacket.fromBytes(data),
  0x3A: (data) => WorkoutSummaryPacket1.fromBytes(data),
  0x3B: (data) => HeartRateBeltPacket.fromBytes(data),
  0x3C: (data) => WorkoutSummaryPacket2.fromBytes(data),
  0x3D: (data) => ForceCurveData.fromBytes(data),
  0x3E: (data) => StatusData3.fromBytes(data),
};

/// Attempts to parse a multiplexed Concept2 data packet.
/// Returns `null` if the packet ID is unknown or the data is empty.
Concept2CharacteristicData? parsePacket(Uint8List data) {
  if (data.isEmpty) return null;
  final id = data[0];
  final parser = _packetParsers[id];
  debugPrint(
      "packet data: ${data.map((e) => e.toRadixString(16).padLeft(2, '0')).join(',')}");
  return parser?.call(data.sublist(1));
}
