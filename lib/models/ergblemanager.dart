import 'dart:async';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'package:meta/meta.dart';
import 'ergometer.dart';

enum BluetoothConnectionState {
  UNKNOWN,
  UNSUPPORTED,
  UNAUTHORIZED,
  POWERED_ON,
  POWERED_OFF,
  RESETTING,
}

class ErgBleManager {
  static ErgBleManager? _instance;

  @experimental
  List<Ergometer> scanResults = [];

  @experimental
  Stream<List<Ergometer>> get scanResultStream => startErgScan().map((_) {
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

  /// Provide a stream to allow clients to monitor the state of the bluetooth connection.
  Stream<BluetoothConnectionState> monitorBluetoothState() {
    return _manager.observeBluetoothState().map((btState) {
      switch (btState) {
        case BluetoothState.UNKNOWN:
          return BluetoothConnectionState.UNKNOWN;
        case BluetoothState.UNSUPPORTED:
          return BluetoothConnectionState.UNSUPPORTED;
        case BluetoothState.UNAUTHORIZED:
          return BluetoothConnectionState.UNAUTHORIZED;
        case BluetoothState.POWERED_ON:
          return BluetoothConnectionState.POWERED_ON;
        case BluetoothState.POWERED_OFF:
          return BluetoothConnectionState.POWERED_OFF;
        case BluetoothState.RESETTING:
          return BluetoothConnectionState.RESETTING;
      }
    });
  }

  /// Begin scanning for Ergs.
  ///
  /// This begins a scan for bluetooth devices with a filter applied so that only Concept2 Performance Monitors show up.
  /// Bluetooth must be on and adequate permissions must be granted to the app for this to work.
  Stream<Ergometer> startErgScan() {
    return _manager.startPeripheralScan(
        uuids: [Identifiers.C2_ROWING_BASE_UUID]).map((scanResult) {
      Ergometer erg = Ergometer(scanResult.peripheral);
      if (scanResults.indexWhere((element) => element.name == erg.name) == -1) {
        scanResults.add(erg);
      }
      return erg;
    });
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
