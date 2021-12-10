library c2bluetooth;

import 'models/workoutsummary.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class ErgBleManager {
  BleManager _manager = BleManager();

  // ErgBleManager() {}

  void init() {
    _manager.createClient();
  }

  Stream<Ergometer> startErgScan() {
    return _manager.startPeripheralScan(uuids: [
      Identifiers.C2_ROWING_BASE_UUID
    ]).map((scanResult) => Ergometer.fromPeripheral(scanResult.peripheral));
  }

  Future<void> stopErgScan() {
    return _manager.stopPeripheralScan();
  }

  Future<void> destroy() {
    return _manager.destroyClient();
  }
}

class Ergometer {
  Peripheral? _peripheral;

  String get name => _peripheral?.name ?? "Unknown";

  Ergometer.fromPeripheral(Peripheral peripheral) {
    this._peripheral = peripheral;
  }

  Future<void> connectAndDiscover() async {
    if (_peripheral == null) return;

    await _peripheral!.connect();
    await _peripheral!.discoverAllServicesAndCharacteristics();
  }

  Future<void> disconnectOrCancel() async {
    if (_peripheral == null) return;

    return _peripheral?.disconnectOrCancelConnection();
  }

  Stream<WorkoutSummary> monitorForWorkoutSummary() {
    return _peripheral!
        .monitorCharacteristic(Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
            Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID)
        .asyncMap((datapoint) =>
            datapoint.read().then((dp) => WorkoutSummary.fromBytes(dp)));
  }
}
