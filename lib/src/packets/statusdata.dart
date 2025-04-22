import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

import './base.dart';

class StatusData extends ElapsedtimeStampedData {
  double distance;

  static Set<String> get datapointIdentifiers =>
      StatusData.zero().asMap().keys.toSet();

  StatusData.zero() : this.fromBytes(Uint8List(20));

  StatusData.fromBytes(Uint8List data)
      : distance = CsafeIntExtension.fromBytes(data.sublist(3, 6),
                endian: Endian.little) /
            10,
        super.fromBytes(data);

  //TODO: add more data fields here
}

class StatusData1 extends ElapsedtimeStampedData {
  double speed;

  static Set<String> get datapointIdentifiers =>
      StatusData1.zero().asMap().keys.toSet();

  StatusData1.zero() : this.fromBytes(Uint8List(20));

  StatusData1.fromBytes(Uint8List data)
      : speed = CsafeIntExtension.fromBytes(data.sublist(3, 5),
                endian: Endian.little) /
            1000,
        super.fromBytes(data);
  //TODO: add more data fields here
}

class StatusData2 extends ElapsedtimeStampedData {
  int intervalCount;

  static Set<String> get datapointIdentifiers =>
      StatusData2.zero().asMap().keys.toSet();

  StatusData2.zero() : this.fromBytes(Uint8List(20));

  StatusData2.fromBytes(Uint8List data)
      : intervalCount = data.elementAt(3),
        super.fromBytes(data);
  //TODO: add more data fields here

}
