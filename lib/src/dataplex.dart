import 'dart:typed_data';

import './packets/statusdata.dart';
import './packets/strokedata.dart';

/// Handles mapping between data coming from bluetooth notfications and the data the user requested.
/// This gives c2bluetooth a layer of flexibility and decouples the incoming bluetooth data from the output going to an application so that c2bluetooth has space to potentially optimize the data being used
class Dataplex {
  // data access speed

  ///Keeps track of how many characteristics we are currently receiving notifications for
  int _currentSubscriptionCount = 0;

  Stream<Map<String, dynamic>> createStream(Set<String> keysRequested) {
    
  }

  // String _packetType(Uint8List data) {
  //   switch (data[0]) {
  //     case 0x31:
  //       StatusData parsed = StatusData.fromBytes(data.sublist(1));
  //       print(parsed.elapsedTime.toString());
  //       print("distance ${parsed.distance.toString()}");

  //       return "status";
  //     case 0x32:
  //       StatusData1 parsed = StatusData1.fromBytes(data.sublist(1));
  //       print(parsed.elapsedTime.toString());
  //       print("speed ${parsed.speed.toString()}");

  //       return "Status 1";
  //     case 0x33:
  //       StatusData2 parsed = StatusData2.fromBytes(data.sublist(1));
  //       print(parsed.elapsedTime.toString());
  //       // print("intervalcount ${parsed.intervalCount.toString()}");
  //       return "Status 2";
  //     case 0x35:
  //       return "stroke data";
  //     case 0x36:
  //       return "stroke data 1";
  //     case 0x37:
  //       return "split/interval data";
  //     case 0x38:
  //       return "split/interval data 2";
  //     case 0x39:
  //       return "workout data";
  //     case 0x3A:
  //       return "workout data 1";
  //     case 0x3C:
  //       print(data);
  //       return "workout data 2";
  //     default:
  //       return "Unknown";
  //   }
  // }
}
