import 'dart:async';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'ergometer.dart';

class ErgBleManager {
  static ErgBleManager? _instance;

  List<Ergometer> scanResults = [];
  Stream<List<Ergometer>> get scanResultStream =>
      startErgScan().asyncMap((event) {
        print(scanResults);
        return scanResults;
      });

  BleManager _manager;

  factory ErgBleManager() {
    var instance = _instance;
    if (instance == null) {
      instance = ErgBleManager._fromManager(BleManager());
      instance.init();
      _instance = instance;
    }

    return instance;
  }

  ErgBleManager._fromManager(this._manager) {
    // scanResultStream =
  }

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
    ]).map((scanResult) => Ergometer(scanResult.peripheral));
  }

  /// Stops scanning for ergs
  Future<void> stopErgScan() {
    scanResults = [];
    return _manager.stopPeripheralScan();
  }

  /// Clean up/destroy/deallocate resources so that they are availalble again
  Future<void> destroy() {
    return _manager.destroyClient();
  }
}
