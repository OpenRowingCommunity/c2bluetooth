import 'dart:async';

import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:c2bluetooth/exceptions/c2bluetooth_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'ergometer.dart';

class ErgBleManager {
  final FlutterReactiveBle _manager;
  StreamSubscription<BleStatus>? _bleStatus;
  List<Ergometer> _scannedErgometers = [];

  ErgBleManager() : _manager = FlutterReactiveBle();

  /// Allow [ErgBleManager] to be tested using a Mocked bluetooth client
  @visibleForTesting
  ErgBleManager.withDependency({FlutterReactiveBle? bleClient})
      : _manager = bleClient ?? FlutterReactiveBle();

  /// Begin scanning for Ergs.
  ///
  /// Monitor the device's bluetooth status and raise when the device is not ready anymore
  /// This begins a scan for bluetooth devices with a filter applied so that only Concept2 Performance Monitors show up.
  /// Bluetooth must be on and adequate permissions must be granted for this to work.
  Stream<Ergometer> startErgScan() {
    _bleStatus = _manager.statusStream.listen((bleStatus) {
      if (bleStatus != BleStatus.ready)
        throw C2ConnectionException('Bluetooth Error: device $bleStatus');
    });
    return _manager
        .scanForDevices(
            withServices: [Uuid.parse(Identifiers.C2_ROWING_BASE_UUID)])
        .handleError((error) =>
            throw C2ConnectionException('Error when scanning', error))
        .map((scanResult) {
          _scannedErgometers.add(Ergometer(scanResult, bleClient: _manager));
          return _scannedErgometers.last;
        });
  }

  /// Clean up/destroy/deallocate resources so that they are availalble again
  Future<void> destroy() {
    _bleStatus?.cancel();
    _scannedErgometers.clear();
    return _manager.deinitialize();
  }
}
