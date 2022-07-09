import 'package:c2bluetooth/backends/interface/bluetoothclient.dart';
import 'package:c2bluetooth/backends/interface/bluetoothdevice.dart';
import 'package:c2bluetooth/backends/interface/bluetoothscanresult.dart';

/// an implementation of the ble backend interface for FlutterBleLib and libraries based on it.
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class FlutterReactiveClient extends BluetoothClient {

  void createClient() {
  }
  // TODO: make a ScanResult like class
  Stream<BluetoothScanResult> startPeripheralScan({List<String>? uuids}) {}

  Future<void> stopPeripheralScan() {
  }

  Future<void> destroyClient() {
  }
}

class FlutterReactiveDevice extends BluetoothDevice {
  connect() {}

  discoverAllServicesAndCharacteristics() {}

  Future<void> disconnectOrCancelConnection() {}

  monitorCharacteristic(String c2_rowing_primary_service_uuid,
      String c2_rowing_end_of_workout_summary_characteristic_uuid) {}

  observeConnectionState() {}
  writeCharacteristic() {}

  readCharacteristic() {}
}
