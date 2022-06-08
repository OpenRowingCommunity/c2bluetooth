import 'dart:async';
import 'dart:typed_data';
import 'package:c2bluetooth/models/c2datastreamcontroller.dart';
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';

import './packets/statusdata.dart';
import './packets/strokedata.dart';
import './packets/segmentdata.dart';
import './packets/workoutsummary.dart';
import './packets/forcecurvepacket.dart';

import 'helpers.dart';
import 'packets/base.dart';

/// Handles mapping between data coming from bluetooth notfications and the data the user requested.
/// This gives c2bluetooth a layer of flexibility and decouples the incoming bluetooth data from the output going to an application so that c2bluetooth has space to potentially optimize the data being used
class Dataplex {
  // data access speed

  Peripheral device;

  List<C2DataStreamController> outgoingStreams = [];

  Map<String, StreamSubscription> currentSubscriptions = Map();

  Map<String, Type> characteristicToPacketMap = {
    Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID:
        WorkoutSummaryPacket,
    Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC2_UUID:
        WorkoutSummaryPacket2,
  };

  Dataplex(this.device);

  ///Keeps track of how many characteristics we are currently receiving notifications for
  int _currentSubscriptionCount = 0;

  Stream<Map<String, dynamic>> createStream(Set<String> keysRequested) {
    C2DataStreamController controller =
        new C2DataStreamController(keysRequested);

    controller.onCancel = _generateOutputCloseListener(controller);

    //TODO: set up close listener.

    outgoingStreams.add(controller);

    return controller.stream;
  }

  /// Generate a function that removes the provided controller from the outgoing streams list
  FutureOr<void> Function()? _generateOutputCloseListener(
      C2DataStreamController controller) {
    FutureOr<void> remove() {
      outgoingStreams.remove(controller);
    }

    return remove;
  }

  void _addSubscription(
      String serviceUuid, String characteristicUuid, int? dataIdentifier) {
    StreamSubscription sub = device
        .monitorCharacteristic(serviceUuid, characteristicUuid)
        .listen((data) => data.read().then((bytes) {
              // manually insert an identification byte if this characteristic doesnt have one already
              if (dataIdentifier != null) {
                bytes.insert(0, dataIdentifier);
              }
              _readPacket(bytes);
            }));
    currentSubscriptions.addEntries({characteristicUuid: sub}.entries);
  }

  void _readPacket(Uint8List data) {
    Concept2CharacteristicData? packet = parsePacket(data);

    if (packet != null) {
      //send the data to the outgoing streams
      for (var stream in outgoingStreams) {
        stream.add(packet.asMap());
      }
    } else {
      print("unknown packet found");
      print("packet data: $data");
    }
  }

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
