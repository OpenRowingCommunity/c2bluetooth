import 'dart:typed_data';

import 'workoutsummary.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:rxdart/rxdart.dart';

class Ergometer {
  Peripheral? _peripheral;

  /// Get the name (i.e. "PM5 " + serial number) of this erg.
  ///
  /// Returns "unknown" if the erg does not report a name
  String get name => _peripheral?.name ?? "Unknown";

  /// Create an Ergometer from a FlutterBleLib peripheral object
  ///
  /// This is mainly intended for internal use
  Ergometer.fromPeripheral(Peripheral peripheral) {
    // TODO: make me private somehow
    this._peripheral = peripheral;
  }

  /// Connect to this erg and discover the services and characteristics that it offers
  Future<void> connectAndDiscover() async {
    if (_peripheral == null) return;

    await _peripheral!.connect();
    await _peripheral!.discoverAllServicesAndCharacteristics();
  }

  // Disconnect from this erg or cancel the connection
  Future<void> disconnectOrCancel() async {
    if (_peripheral == null) return;

    return _peripheral?.disconnectOrCancelConnection();
  }

  /// Returns a stream of [WorkoutSummary] objects upon completion of any programmed piece or a "just row" piece that is longer than 1 minute.
  Stream<WorkoutSummary> monitorForWorkoutSummary() {
    Stream<Uint8List> ws = _peripheral!
        .monitorCharacteristic(Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
            Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID)
        .asyncMap((datapoint) => datapoint.read().then((dp) {
              print(dp);
              return dp;
            }));
    Stream<Uint8List> ws2 = _peripheral!
        .monitorCharacteristic(Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
            Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC2_UUID)
        .asyncMap((datapoint) => datapoint.read().then((dp) {
              print(dp);
              return dp;
            }));

    return Rx.zip2(ws, ws2, (Uint8List a, Uint8List b) {
      List<int> aL = a.toList();
      aL.addAll(b.toList());
      Uint8List tl = Uint8List.fromList(aL);
      print(tl);
      return WorkoutSummary.fromBytes(tl);
    });
  }
}