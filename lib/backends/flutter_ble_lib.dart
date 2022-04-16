import 'package:c2bluetooth/backends/interface/bluetoothclient.dart';
import 'package:c2bluetooth/backends/interface/bluetoothdevice.dart';

/// an implementation of the ble backend interface for FlutterBleLib and libraries based on it.
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';

class FlutterBleLibClient extends BluetoothClient {
  BleManager _client = BleManager();

  void createClient() {
    _client.createClient();
  }

  startPeripheralScan({List<String>? uuids}) {
    _client.startPeripheralScan(uuids: uuids ?? []);
  }

  Future<void> stopPeripheralScan() {
    return _client.stopPeripheralScan();
  }

  Future<void> destroyClient() {
    return _client.destroyClient();
  }
}

class FlutterBleLibDevice extends BluetoothDevice {
  connect() {}

  discoverAllServicesAndCharacteristics() {}

  Future<void> disconnectOrCancelConnection() {}

  monitorCharacteristic(String c2_rowing_primary_service_uuid,
      String c2_rowing_end_of_workout_summary_characteristic_uuid) {}

  writeCharacteristic() {}

  readCharacteristic() {}
  Stream<BluetoothConnectionState> observeConnectionState() {
    return _peripheral.observeConnectionState().asyncMap((connectionState) {
      switch (connectionState) {
        case PeripheralConnectionState.connecting:
          return BluetoothConnectionState.connecting;
        case PeripheralConnectionState.connected:
          return BluetoothConnectionState.connected;
        case PeripheralConnectionState.disconnecting:
          return BluetoothConnectionState.disconnected;
        case PeripheralConnectionState.disconnected:
          return BluetoothConnectionState.disconnected;
        default:
          return BluetoothConnectionState.disconnected;
      }
    });
  }
}
