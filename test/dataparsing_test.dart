import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

import '../lib/src/packets/statusdata.dart';
import '../lib/src/packets/strokedata.dart';
import '../lib/src/packets/segmentdata.dart';
import '../lib/src/packets/workoutsummary.dart';
import '../lib/src/packets/forcecurvepacket.dart';

import '../lib/src/packets/base.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:csv/csv.dart';
// import '../lib/src/helpers.dart';
// import '../lib/models/ergblemanager.dart';

void main() {
  group("test-multiplex-data6", () {
    test('- print', () async {
      final input = new File('./test/test-multiplex-data6.csv').openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter(eol: '\n'))
          .toList();
      // print(fields);

      for (List<dynamic> row in fields) {
        List<int> ints = row.cast<int>();
        Uint8List data = Uint8List.fromList(ints);
        print(parsePacket(data));
      }
    });
  });
}

Concept2CharacteristicData? parsePacket(Uint8List data) {
  switch (data[0]) {
    case 0x31:
      StatusData parsed = StatusData.fromBytes(data.sublist(1));
      print("elapsed time :${parsed.elapsedTime.toString()}");
      print("distance ${parsed.distance.toString()}");

      return parsed;
    case 0x32:
      StatusData1 parsed = StatusData1.fromBytes(data.sublist(1));
      print("elapsed time :${parsed.elapsedTime.toString()}");
      print("speed ${parsed.speed.toString()}");

      return parsed;
    case 0x33:
      StatusData2 parsed = StatusData2.fromBytes(data.sublist(1));
      print("elapsed time :${parsed.elapsedTime.toString()}");
      // print("intervalcount ${parsed.intervalCount.toString()}");
      return parsed;
    case 0x35:
      return StrokeData.fromBytes(data.sublist(1));
    case 0x36:
      return StrokeData2.fromBytes(data.sublist(1));
    case 0x37:
      return SegmentData.fromBytes(data.sublist(1));
    case 0x38:
      var parsed = SegmentData2.fromBytes(data.sublist(1));
      print("elapsed time :${parsed.elapsedTime.toString()}");

      return parsed;
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
