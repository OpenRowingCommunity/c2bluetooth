import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

import './base.dart';

class StatusData extends DurationstampedData {
  double distance;

  StatusData.fromBytes(Uint8List data)
      : distance = CsafeIntExtension.fromBytes(data.sublist(3, 6),
                endian: Endian.little) /
            10,
        super.fromBytes(data);

  //TODO: add more data fields here
}

class StatusData1 extends DurationstampedData {
  double speed;

  StatusData1.fromBytes(Uint8List data)
      : speed = CsafeIntExtension.fromBytes(data.sublist(3, 5),
                endian: Endian.little) /
            1000,
        super.fromBytes(data);
  //TODO: add more data fields here
}

class StatusData2 extends DurationstampedData {
  int intervalCount;

  StatusData2.fromBytes(Uint8List data)
      : intervalCount = data.elementAt(3),
        super.fromBytes(data);
  //TODO: add more data fields here

}
