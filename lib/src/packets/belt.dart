import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

import './base.dart';
import 'keys.dart';

/// Represents the heart rate belt packet
class HeartRateBelt extends Concept2CharacteristicData {
  int manufacturerID;
  int deviceType;
  int beltID;

  static Set<String> get datapointIdentifiers =>
      HeartRateBelt.zero().asMap().keys.toSet();

  /// Construct a WorkoutSummary from the bytes returned from the erg
  HeartRateBelt.fromBytes(Uint8List data)
      : manufacturerID = data[0],
        deviceType = data[1],
        beltID = CsafeIntExtension.fromBytes(data.sublist(2, 6));

  HeartRateBelt.zero() : this.fromBytes(Uint8List(19));

  Map<String, dynamic> asMap() => {
        Keys.BELT_MANUFACTURER_ID_KEY: manufacturerID,
        Keys.BELT_DEVICE_TYPE_KEY: deviceType,
        Keys.BELT_DEVICE_ID_KEY: beltID,
      };
}
