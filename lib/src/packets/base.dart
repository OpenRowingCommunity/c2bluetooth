import 'dart:typed_data';
import 'package:c2bluetooth/extensions.dart';

///Represents a data packet from Concept2 that is stamped with a date.
class TimestampedData {
  DateTime timestamp;

  TimestampedData.fromBytes(Uint8List bytes)
      : timestamp = Concept2DateExtension.fromBytes(bytes.sublist(0, 4));
}

///Represents a data packet from Concept2 that is stamped with a duration.

class DurationstampedData {
  Duration elapsedTime;

  DurationstampedData.fromBytes(Uint8List data)
      : elapsedTime = Concept2DurationExtension.fromBytes(data.sublist(0, 3));
}
