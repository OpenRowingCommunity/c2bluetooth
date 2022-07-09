import 'dart:typed_data';

class BluetoothService {
  String get identifier => "";

  // List<BluetoothCharacteristic> characteristics;
}

class BluetoothCharacteristic {
  String get identifier => "";
  

  Future<Uint8List> read();

  Future<void> write(Uint8List value, bool withResponse);

  Stream<Uint8List> monitor();
}
