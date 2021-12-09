library c2bluetooth;

import 'models/workoutsummary.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class ErgBleManager {
  BleManager manager = BleManager();

  // ErgBleManager() {}

  void init() {
    manager.createClient();
  }

  Stream<Ergometer> startErgScan() {
    // TODO: filter by UUID
    return manager
        .startPeripheralScan()
        .map((scanResult) => Ergometer.fromPeripheral(scanResult.peripheral));
  }

  Future<void> stopErgScan() {
    return manager.stopPeripheralScan();
  }

  Future<void> destroy() {
    return manager.destroyClient();
  }
}

class Ergometer {
  Peripheral? peripheral;

  Ergometer.fromPeripheral(Peripheral peripheral) {
    this.peripheral = peripheral;
  }

  Future<void> connectAndDiscover() async {
    if (peripheral == null) return;

    await peripheral!.connect();
    await peripheral!.discoverAllServicesAndCharacteristics();
  }

  Future<void> disconnectOrCancel() async {
    if (peripheral == null) return;

    return peripheral?.disconnectOrCancelConnection();
  }

  Stream<WorkoutSummary> monitorForWorkoutSummary() {
    return peripheral!
        .monitorCharacteristic(Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
            Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID)
        .asyncMap((datapoint) =>
            datapoint.read().then((dp) => WorkoutSummary.fromBytes(dp)));
  }
}
