import 'dart:async';
import 'dart:typed_data';
import 'package:c2bluetooth/models/c2datastreamcontroller.dart';
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';

import './packets/statusdata.dart';
import './packets/strokedata.dart';

/// Handles mapping between data coming from bluetooth notfications and the data the user requested.
/// This gives c2bluetooth a layer of flexibility and decouples the incoming bluetooth data from the output going to an application so that c2bluetooth has space to potentially optimize the data being used
class Dataplex {
  // data access speed

  Peripheral device;

  List<C2DataStreamController> outgoingStreams = [];

  Map<String, StreamSubscription> currentSubscriptions = Map();

  Dataplex(this.device);

  ///Keeps track of how many characteristics we are currently receiving notifications for
  int _currentSubscriptionCount = 0;

  Stream<Map<String, dynamic>> createStream(Set<String> keysRequested) {
    C2DataStreamController controller =
        new C2DataStreamController(keysRequested);

    //TODO: set up close listener.

    outgoingStreams.add(controller);

    return controller.stream;
  }

  void _addSubscription(String serviceUuid, String characteristicUuid) {
    StreamSubscription sub = device
        .monitorCharacteristic(serviceUuid, characteristicUuid)
        .listen((data) => data.read().then((bytes) => _readPacket(bytes)));
    currentSubscriptions.addEntries({characteristicUuid: sub}.entries);
  }

  void _readPacket(Uint8List data) {}
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

  void dispose() {
    // clear current subscriptions
    for (var entry in currentSubscriptions.entries) {
      var key = entry.key;
      var subscription = entry.value;

      subscription.cancel();
      currentSubscriptions.remove(key);
    }
    // end all current output streams
  }
}
