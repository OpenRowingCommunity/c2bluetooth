import 'dart:typed_data';

import 'package:c2bluetooth/backends/interface/bluetoothclient.dart';
import 'package:c2bluetooth/backends/interface/bluetoothdevice.dart';
import 'package:c2bluetooth/backends/interface/bluetoothscanresult.dart';

/// an implementation of the ble backend interface for FlutterBleLib and libraries based on it.
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';

class FlutterBleLibClient extends BluetoothClient {
  BleManager _client = BleManager();

  void createClient() {
    _client.createClient();
  }

  Stream<BluetoothScanResult> startPeripheralScan({List<String>? uuids}) {
    return _client
        .startPeripheralScan(uuids: uuids ?? [])
        .asyncMap((scanResult) {
      return BluetoothScanResult(
          FlutterBleLibDevice._fromPeripheral(scanResult.peripheral),
          scanResult.rssi);
    });
  }

  Future<void> stopPeripheralScan() {
    return _client.stopPeripheralScan();
  }

  Future<void> destroyClient() {
    return _client.destroyClient();
  }
}

class FlutterBleLibDevice extends BluetoothDevice {
  Peripheral _peripheral;

  String? get name => _peripheral.name;
  String get identifier => _peripheral.identifier;

  FlutterBleLibDevice._fromPeripheral(Peripheral p) : _peripheral = p;


  Future<void> connect() {
    return _peripheral.connect();
  }

  Future<void> discoverAllServicesAndCharacteristics() {
    return _peripheral.discoverAllServicesAndCharacteristics();
  }

  Future<void> disconnectOrCancelConnection() {
    return _peripheral.disconnectOrCancelConnection();
  }

  Stream<> monitorCharacteristic(String serviceUuid, String characteristicUuid) {
    return _peripheral.monitorCharacteristic(serviceUuid, characteristicUuid);
  }

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

  Future<void> writeCharacteristic() {
    return _peripheral.writeCharacteristic(serviceUuid, characteristicUuid, value, withResponse).then((characteristic) => {
  
    });
  }

  Future<Uint8List> readCharacteristic() {
    return _peripheral.readCharacteristic(serviceUuid, characteristicUuid).then();
  }
}
