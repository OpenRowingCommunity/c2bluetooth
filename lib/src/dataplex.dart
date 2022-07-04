import 'dart:async';
import 'dart:typed_data';
import 'package:c2bluetooth/models/c2datastreamcontroller.dart';
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';

import '../constants.dart' as Identifiers;
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

  /// A map of incoming UUID's to the data keys they support.
  Map<String, Set<String>> characteristicToDataKeyMap = {
    Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID:
        WorkoutSummaryPacket.datapointIdentifiers,
    Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC2_UUID:
        WorkoutSummaryPacket2.datapointIdentifiers,
  };

  Dataplex(this.device);

  ///Keeps track of how many characteristics we are currently receiving notifications for
  int _currentSubscriptionCount = 0;

  /// Create and return a new stream that provides the requested data
  Stream<Map<String, dynamic>> createStream(Set<String> keysRequested) {
    C2DataStreamController controller =
        new C2DataStreamController(keysRequested);

    //set up close listener.
    controller.onCancel = _generateOutputCloseListener(controller);

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

  /// set up a new subscription to data from an erg.
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

  /// Read a packet from an incoming stream (from the erg) and redistribute it to all outgoing streams
  void _readPacket(Uint8List data) {
    Concept2CharacteristicData? packet = parsePacket(data);

    if (packet != null) {
      //send the data to the outgoing streams
      for (var stream in outgoingStreams) {
        stream.add(packet.asMap());
      }
    } else {
      print("Couldnt parse packet from data");
      print("packet data: $data");
    }
  }

  /// Ensure that we have enough data coming in from the erg to satisfy all the currently requested data
  ///
  /// if there isnt enough data, set up some new subscriptions for data from the erg.
  /// if we have too many subscriptions and the same data can be had with less, then readjust the streams so we are being efficient.
  ///
  /// For now this will likely just use the multiplexed data since that basically contains everything in one stream and will be easy to implement
  void _validateStreams() {
    //loop over all outgoingStreams and collect a set of every key that is requested

    Set<String> requestedKeys = {};
    for (var outgoingStream in outgoingStreams) {
      requestedKeys.addAll(outgoingStream.datapoint_identifiers.toSet());
    }

    //get a set of what keys are coming in from the active subscriptions
    Set<String> incomingUUIDs = currentSubscriptions.keys.toSet();

    Set<String> incomingKeys = {};

    for (var uuid in incomingUUIDs) {
      Set<String>? identifiers = characteristicToDataKeyMap[uuid];
      if (identifiers != null) {
        incomingKeys.addAll(identifiers);
      }
    }

    // dind the difference of the two to see what we are missing
    Set<String> missingKeys = requestedKeys.difference(incomingKeys);

    // do magic to figure out what characteristics to add to get those additional keys

    //make a list of those characteristics

    //find out if we have any unused characteristics

    //
  }

  /// closes down this instance by cancelling all streams
  void dispose() {
    // clear current subscriptions
    for (var entry in currentSubscriptions.entries) {
      var key = entry.key;
      var subscription = entry.value;

      subscription.cancel();
      currentSubscriptions.remove(key);
    }
    // end all current output streams
    for (var stream in outgoingStreams) {
      stream.close();
    }
  }
}
