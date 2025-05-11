import 'dart:typed_data';

import 'package:c2bluetooth/enums.dart';
import 'package:c2bluetooth/src/helpers.dart';
import 'package:c2bluetooth/src/packets/keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Handle mutliplexed data', () {
    test('parsePacket handles 0x37 SegmentData1', () {
      // Construct a byte array representing a packet.
      final data = Uint8List.fromList([
        0x37, // packet ID
        0xE8, 0x03, 0x00, // elapsedTime: 1000 (0x0003E8) => 10 seconds
        0xE8, 0x03, 0x00, // elapsedDistance: 1000 (0x0003E8) => 100 meters
        0x88, 0x13, 0x00, // segment time:
        0x88, 0x13, 0x00, // segment distance:
        0x88, 0x13, // interval rest time:
        0x88, 0x13, // interval rest distance:
        0x05, // segment type: rest undefined
        0x03, // segment number:
      ]);
      expect(data.lengthInBytes, equals(19));
      final status = parsePacket(data);
      final map = status!.asMap();
      expect(map[Keys.ELAPSED_TIME_KEY], equals(Duration(seconds: 10)));
      expect(map[Keys.ELAPSED_DISTANCE_KEY], equals(100.0));
      expect(map[Keys.SEGMENT_TIME_KEY], equals(500));
      expect(map[Keys.SEGMENT_DISTANCE_KEY], equals(5000));
      expect(map[Keys.SEGMENT_TYPE_KEY], equals(IntervalType.RESTUNDEFINED));
      expect(map[Keys.SEGMENT_NUMBER_KEY], equals(3));
    });
  });
}
