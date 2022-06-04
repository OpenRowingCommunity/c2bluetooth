import 'dart:typed_data';
import 'package:c2bluetooth/extensions.dart';

import 'keys.dart' as Keys;

/// An empty superclass to represent all types of data formats that come from Concept2 bluetooth characteristics
class Concept2CharacteristicData {
  Map<String, dynamic> asMap() {
    return <String, dynamic>{};
  }
}

///Represents a data packet from Concept2 that is stamped with a date.
class TimestampedData extends Concept2CharacteristicData {
  DateTime timestamp;

  TimestampedData.fromBytes(Uint8List bytes)
      : timestamp = Concept2DateExtension.fromBytes(bytes.sublist(0, 4));

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({Keys.WORKOUT_TIMESTAMP_KEY: timestamp});
    return map;
  }
}

///Represents a data packet from Concept2 that begins with the current elapsed time
class ElapsedtimeStampedData extends Concept2CharacteristicData {
  Duration elapsedTime;

  ElapsedtimeStampedData.fromBytes(Uint8List data)
      : elapsedTime = Concept2DurationExtension.fromBytes(data.sublist(0, 3));

  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = super.asMap();
    map.addAll({Keys.ELAPSED_TIME_KEY: elapsedTime});
    return map;
  }
}
