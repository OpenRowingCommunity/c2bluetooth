///A wrapper around some bluetooth library that makes it easy to change what bluetooth backend is being used without affecting the operation of c2bluetooth.
///


abstract class BluetoothClient {
  void createClient() {}

  startPeripheralScan({List<String> uuids}) {}

  Future<void> stopPeripheralScan() {}

  Future<void> destroyClient() {}

  

}