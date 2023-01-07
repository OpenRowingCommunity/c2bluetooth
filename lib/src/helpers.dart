import 'dart:typed_data';

import './packets/statusdata.dart';
import './packets/strokedata.dart';
import './packets/segmentdata.dart';
import './packets/workoutsummary.dart';
import './packets/forcecurvepacket.dart';

import './packets/base.dart';

/// Parse a packet based on its type
///
/// packets are identified by either the first byte (if no [dataIdentifier] is provided) or the provided [dataIdentifier]
/// The packet is parsed differently on which of these methods is used to identify it.
/// Multiplexed packets come from concept2 with the identifier baked in. To correctly parse these, do NOT provide a [dataIdentifier]
///
/// regular, non-multiplexed data needs to have a data identifier provided separately so this method knows what characteristic it came from.
Concept2CharacteristicData? parsePacket(Uint8List data, {int? dataIdentifier}) {
  int offset = 0;

  bool isMultiplexed = dataIdentifier == null;

  if (isMultiplexed) {
    offset = 1; //remove the identification byte
  }

  dataIdentifier = dataIdentifier ?? data[0];

  switch (dataIdentifier) {
    case 0x31:
      return StatusData.fromBytes(data.sublist(offset));
    case 0x32:
      return StatusData1.fromBytes(data.sublist(offset));
    case 0x33:
      return StatusData2.fromBytes(data.sublist(offset));
    case 0x35:
      return StrokeData.fromBytes(data.sublist(offset));
    case 0x36:
      return StrokeData2.fromBytes(data.sublist(offset));
    case 0x37:
      return SegmentData1.fromBytes(data.sublist(offset));
    case 0x38:
      return SegmentData2.fromBytes(data.sublist(offset));
    case 0x39:
      return isMultiplexed
          ? WorkoutSummaryPacketMultiplexed.fromBytes(data.sublist(offset))
          : WorkoutSummaryPacket.fromBytes(data.sublist(offset));
    case 0x3A:
      return isMultiplexed
          ? WorkoutSummaryPacket2Multiplexed.fromBytes(data.sublist(offset))
          : WorkoutSummaryPacket2.fromBytes(data.sublist(offset));
    case 0x3C:
      return ForceCurveData.fromBytes(data.sublist(offset));
    default:
      return null;
  }
}
