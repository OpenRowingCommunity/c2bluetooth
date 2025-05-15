import 'dart:async';
import 'dart:typed_data';
import 'package:c2bluetooth/models/c2datastreamcontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

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

  final FlutterReactiveBle _flutterReactiveBle;

  DiscoveredDevice _device;
  final ParsePacketFn _parsePacket;
  List<C2DataStreamController> outgoingStreams = [];

  /// Map of characteristic UUID's to the active subscription instance for that characteristic
  Map<String, StreamSubscription> currentSubscriptions = Map();

  Set<String> allDatapointIdentifiers = {
    ...StatusData.datapointIdentifiers,
    ...StatusData1.datapointIdentifiers,
    ...StatusData2.datapointIdentifiers,
    ...StrokeData.datapointIdentifiers,
    ...StrokeData2.datapointIdentifiers,
    ...SegmentData1.datapointIdentifiers,
    ...SegmentData2.datapointIdentifiers,
    ...WorkoutSummaryPacket.datapointIdentifiers,
    ...WorkoutSummaryPacket2.datapointIdentifiers,
    ...ForceCurveData.datapointIdentifiers
  };

  /// A map of incoming UUID's to the data keys they support.
  Map<String, Set<String>> characteristicToDataKeyMap = {
    Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID:
        WorkoutSummaryPacket.datapointIdentifiers,
    Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC2_UUID:
        WorkoutSummaryPacket2.datapointIdentifiers,
  };

  Dataplex(
    this._device,
    bleClient, {
    @visibleForTesting ParsePacketFn? parsePacketFn,
  })  : _flutterReactiveBle = bleClient,
        _parsePacket = parsePacketFn ?? parsePacket {}

  ///Keeps track of how many characteristics we are currently receiving notifications for
  int _currentSubscriptionCount = 0;

  /// Create and return a new stream that provides the requested data
  Stream<Map<String, dynamic>> createStream(Set<String> keysRequested) {
    C2DataStreamController controller =
        new C2DataStreamController(keysRequested);

    //set up close listener.
    controller.onCancel = _generateOutputCloseListener(controller);

    outgoingStreams.add(controller);

    // Multiplexed characteristic during initial stream creation
    // TODO: This section will be removed later when _validateStreams is mature
    if (currentSubscriptions.isEmpty) {
      _addSubscription(
          Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
          Identifiers.C2_ROWING_MULTIPLEXED_INFORMATION_CHARACTERISTIC_UUID,
          null);
    }

    return controller.stream;
  }

  /// Generates a function to remove the provided controller from the outgoing streams list
  /// This is useful for handling when consumers of outging streams cloose the streams themselves
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
    var characteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(serviceUuid),
        characteristicId: Uuid.parse(characteristicUuid),
        deviceId: _device.id);

    // this stream should get cancelled in [dispose]
    // ignore: cancel_subscriptions
    StreamSubscription sub = _flutterReactiveBle
        .subscribeToCharacteristic(characteristic)
        .asyncMap((datapoint) => Uint8List.fromList(datapoint))
        .listen((bytes) {
      // manually insert an identification byte if this characteristic doesnt have one already
      if (dataIdentifier != null) {
        bytes.insert(0, dataIdentifier);
      }
      _readPacket(bytes);
    });
    currentSubscriptions.addEntries({characteristicUuid: sub}.entries);
  }

  /// Read a packet from an incoming stream (from the erg) and redistribute it to all outgoing streams
  void _readPacket(Uint8List data) {
    Concept2CharacteristicData? packet = _parsePacket(data);

    if (packet != null) {
      //send the data to the outgoing streams
      for (var stream in outgoingStreams) {
        stream.add(packet.asMap());
      }
    } else {
      print("Couldnt parse packet from data");
      print(
          "packet data: ${data.map((e) => e.toRadixString(16).padLeft(2, '0')).join(',')}");
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
    for (var sub in currentSubscriptions.values) {
      // clear current subscriptions
      sub.cancel();
    }
    currentSubscriptions.clear();

    for (var stream in outgoingStreams) {
      // end all current output streams
      stream.close();
    }
    outgoingStreams.clear();
  }
}
