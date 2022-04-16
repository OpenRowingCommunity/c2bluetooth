import 'package:c2bluetooth/backends/interface/bluetoothscanresult.dart';

/// A bluetooth client to scan for devices and get bluetooth communication started
abstract class BluetoothClient {
  void createClient() {}

  Stream<BluetoothScanResult> startPeripheralScan({List<String> uuids});

  Future<void> stopPeripheralScan() {}

  Future<void> destroyClient() {}
}
