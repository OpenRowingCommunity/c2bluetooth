import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

import './base.dart';
import 'keys.dart';

/// Represents the heart rate belt packet
class HeartRateBeltPacket extends Concept2CharacteristicData {
  int manufacturerID;
  int deviceType;
  int beltID;

  static Set<String> get datapointIdentifiers =>
      HeartRateBeltPacket.zero().asMap().keys.toSet();

  /// Construct a WorkoutSummary from the bytes returned from the erg
  HeartRateBeltPacket.fromBytes(Uint8List data)
      : manufacturerID = data[0],
        deviceType = data[1],
        beltID = CsafeIntExtension.fromBytes(data.sublist(2, 6));

  HeartRateBeltPacket.zero() : this.fromBytes(Uint8List(19));

  Map<String, dynamic> asMap() => {
        Keys.BELT_MANUFACTURER_ID_KEY: manufacturerID,
        Keys.BELT_DEVICE_TYPE_KEY: deviceType,
        Keys.BELT_DEVICE_ID_KEY: beltID,
      };
}
