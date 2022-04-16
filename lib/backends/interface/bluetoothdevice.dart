import 'dart:typed_data';

abstract class BluetoothDevice {
  String? get name => null;
  String get identifier => "";


  Future<void> connect();

  Future<void> discoverAllServicesAndCharacteristics();

  Future<void> disconnectOrCancelConnection();

  Stream<> monitorCharacteristic(String service_uuid, String characteristic_uuid);

  Stream<BluetoothConnectionState> observeConnectionState();
  Future<> writeCharacteristic();

  Future<Uint8List> readCharacteristic();
}

enum BluetoothConnectionState { connecting, connected, disconnected }
