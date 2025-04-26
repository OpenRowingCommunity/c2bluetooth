import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'ergometer.dart';

class ErgBleManager {
  final _manager;

  ErgBleManager({bleClient}) : _manager = bleClient ?? FlutterReactiveBle();

  /// Begin scanning for Ergs.
  ///
  /// This begins a scan for bluetooth devices with a filter applied so that only Concept2 Performance Monitors show up.
  /// Bluetooth must be on and adequate permissions must be granted for this to work.
  Stream<Ergometer> startErgScan() {
    return _manager.scanForDevices(withServices: [
      Uuid.parse(Identifiers.C2_ROWING_BASE_UUID)
    ]).map<Ergometer>(
        (scanResult) => Ergometer(scanResult, bleClient: _manager));
  }

  /// Clean up/destroy/deallocate resources so that they are availalble again
  Future<void> destroy() {
    return _manager.deinitialize();
  }
}
