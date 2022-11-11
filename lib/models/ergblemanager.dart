import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'ergometer.dart';

class ErgBleManager {
  final _manager = FlutterReactiveBle();

  /// Begin scanning for Ergs.
  ///
  /// This begins a scan for bluetooth devices with a filter applied so that only Concept2 Performance Monitors show up.
  /// Bluetooth must be on and adequate permissions must be granted to the app for this to work.
  Stream<Ergometer> startErgScan() {
    return _manager.scanForDevices(withServices: [
      Identifiers.C2_ROWING_BASE_UUID
    ]).map((scanResult) => Ergometer(scanResult));
  }

  /// Stops scanning for ergs

  /// Clean up/destroy/deallocate resources so that they are availalble again
  Future<void> destroy() {
    return _manager.deinitialize();
  }
}
