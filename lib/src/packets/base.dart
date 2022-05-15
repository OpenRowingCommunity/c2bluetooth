import 'dart:typed_data';
import 'package:c2bluetooth/extensions.dart';

/// An empty superclass to represent all types of data formats that come from Concept2 bluetooth characteristics
class Concept2CharacteristicData {}

///Represents a data packet from Concept2 that is stamped with a date.
class TimestampedData extends Concept2CharacteristicData {
  DateTime timestamp;

  TimestampedData.fromBytes(Uint8List bytes)
      : timestamp = Concept2DateExtension.fromBytes(bytes.sublist(0, 4));
}

///Represents a data packet from Concept2 that is stamped with a duration.

class DurationstampedData extends Concept2CharacteristicData {
  Duration elapsedTime;

  DurationstampedData.fromBytes(Uint8List data)
      : elapsedTime = Concept2DurationExtension.fromBytes(data.sublist(0, 3));
}
