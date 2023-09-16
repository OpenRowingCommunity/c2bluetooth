import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

import '../lib/src/packets/statusdata.dart';
import '../lib/src/packets/strokedata.dart';
import '../lib/src/packets/segmentdata.dart';
import '../lib/src/packets/workoutsummary.dart';
import '../lib/src/packets/forcecurvepacket.dart';

import '../lib/src/packets/base.dart';
import '../lib/src/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:csv/csv.dart';
// import '../lib/src/helpers.dart';
// import '../lib/models/ergblemanager.dart';

Future<List<List>> getCsvData(String filename) async {
  final input = new File(filename).openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(new CsvToListConverter(eol: '\n'))
      .toList();
  return fields;
}

void main() {
  group("test-multiplex-data6", () {
    test('- print', () async {
      // print(fields);

      final fields = await getCsvData('./test/test-multiplex-data6.csv');

      for (List<dynamic> row in fields) {
        List<int> ints = row.cast<int>();
        Uint8List data = Uint8List.fromList(ints);
        Concept2CharacteristicData? packet = parsePacket(data);
        if (packet != null) {
          if (packet is ElapsedtimeStampedData) {
            print("elapsed time :${packet.elapsedTime.toString()}");
          }

          if (packet is StatusData1) {
            print("speed ${packet.speed.toString()}");
          }

          if (packet is StatusData2) {
            print("intervalcount ${packet.intervalCount.toString()}");
          }
        }
      }
    });
  });

  group("test StrokeData", () {
    test('parse bytes', () async {
      Uint8List bytes = Uint8List.fromList([
        // 53, came from multiplex, so drop this one
        55,
        9,
        0,
        157,
        1,
        0,
        85,
        115,
        251,
        0,
        175,
        2,
        180,
        0,
        118,
        0,
        7,
        0
      ]);

      expect(bytes.length, 18);

      StrokeData sdata = StrokeData.fromBytes(bytes);

      print(sdata);
    });
  });
}
