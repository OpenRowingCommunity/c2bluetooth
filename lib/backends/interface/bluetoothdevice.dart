abstract class BluetoothDevice {
  get name => null;

  connect() {}

  discoverAllServicesAndCharacteristics() {}

  Future<void> disconnectOrCancelConnection() {}

  monitorCharacteristic(String c2_rowing_primary_service_uuid,
      String c2_rowing_end_of_workout_summary_characteristic_uuid) {}

  observeConnectionState() {}
  writeCharacteristic() {}

  readCharacteristic() {}
}
