import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

import '../lib/src/packets/statusdata.dart';

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
}
