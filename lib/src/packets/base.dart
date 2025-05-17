import 'dart:typed_data';
import 'package:c2bluetooth/extensions.dart';

import 'keys.dart';

/// An empty superclass to represent all types of data formats that come from Concept2 bluetooth characteristics
class Concept2CharacteristicData {
  Map<String, dynamic> asMap() {
    return <String, dynamic>{};
  }
}

///Represents a data packet from Concept2 that is stamped with a date.
class TimestampedData extends Concept2CharacteristicData {
  DateTime timestamp;

  static Set<String> get datapointIdentifiers =>
      TimestampedData.zero().asMap().keys.toSet();

  TimestampedData.zero() : this.fromBytes(Uint8List(20));

  // DatetTime is a modified versions BCD scheme:
  // https://github.com/MoralCode/c2-missing-spec/blob/main/concept2-the-missing-spec.md#date-and-time-formats
  TimestampedData.fromBytes(Uint8List bytes)
      : timestamp = DateTime(
            2000 + ((bytes[1] & 0xFE) >> 1),
            bytes[0] & 0x0F,
            ((bytes[1] & 0x01) << 4) + ((bytes[0] & 0xF0) >> 4),
            bytes[3],
            bytes[2]);

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({Keys.WORKOUT_TIMESTAMP_KEY: timestamp});
    return map;
  }
}

///Represents a data packet from Concept2 that begins with the current elapsed time
class ElapsedtimeStampedData extends Concept2CharacteristicData {
  Duration elapsedTime;

  static Set<String> get datapointIdentifiers =>
      ElapsedtimeStampedData.zero().asMap().keys.toSet();

  ElapsedtimeStampedData.zero() : this.fromBytes(Uint8List(20));

  ElapsedtimeStampedData.fromBytes(Uint8List data)
      : elapsedTime = Concept2DurationExtension.fromBytes(data.sublist(0, 3));

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({Keys.ELAPSED_TIME_KEY: elapsedTime});
    return map;
  }
}
