import 'package:c2bluetooth/backends/interface/bluetoothdevice.dart';

/// The results of a bluetooth scan containing basic device information
class BluetoothScanResult {
  BluetoothDevice device;
  int rssi;

  // some other stuff
  // see https://github.com/dotintent/FlutterBleLib/blob/a4df42eda471f0c53a06b7b9937db8b59585f318/lib/scan_result.dart#L16

  BluetoothScanResult(this.device, this.rssi);
}
