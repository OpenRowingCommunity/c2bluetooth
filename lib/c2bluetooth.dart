library c2bluetooth;

import 'models/workoutsummary.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class ErgBleManager {
  BleManager _manager = BleManager();

  /// perform set up to get the Bluetooth client ready to scan for devices
  void init() {
    _manager.createClient();
  }

  /// Begin scanning for Ergs.
  ///
  /// This begins a scan for bluetooth devices with a filter applied so that only Concept2 Performance Monitors show up.
  /// Bluetooth must be on and adequate permissions must be granted to the app for this to work.
  Stream<Ergometer> startErgScan() {
    return _manager.startPeripheralScan(uuids: [
      Identifiers.C2_ROWING_BASE_UUID
    ]).map((scanResult) => Ergometer.fromPeripheral(scanResult.peripheral));
  }

  /// Stops scanning for ergs
  Future<void> stopErgScan() {
    return _manager.stopPeripheralScan();
  }

  /// Clean up/destroy/deallocate resources so that they are availalble again
  Future<void> destroy() {
    return _manager.destroyClient();
  }
}

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
    return _peripheral!
        .monitorCharacteristic(Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
            Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID)
        .asyncMap((datapoint) =>
            datapoint.read().then((dp) => WorkoutSummary.fromBytes(dp)));
  }
}
