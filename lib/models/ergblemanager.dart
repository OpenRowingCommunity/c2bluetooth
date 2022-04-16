import 'package:c2bluetooth/backends/flutter_ble_lib.dart';
import 'package:c2bluetooth/backends/interface/bluetoothclient.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'ergometer.dart';

class ErgBleManager {
  BluetoothClient _manager;

  ErgBleManager({backend = FlutterBleLibClient}) : _manager = backend() {
    /// perform set up to get the Bluetooth client ready to scan for devices
    _manager.createClient();
  }

  /// Begin scanning for Ergs.
  ///
  /// This begins a scan for bluetooth devices with a filter applied so that only Concept2 Performance Monitors show up.
  /// Bluetooth must be on and adequate permissions must be granted to the app for this to work.
  Stream<Ergometer> startErgScan() {
    return _manager.startPeripheralScan(uuids: [
      Identifiers.C2_ROWING_BASE_UUID
    ]).map((scanResult) => Ergometer(scanResult.peripheral));
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
