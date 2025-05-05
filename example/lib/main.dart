import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:c2bluetooth/c2bluetooth.dart';

void main() => runApp(const MaterialApp(home: QuickstartPage()));

class QuickstartPage extends StatefulWidget {
  const QuickstartPage({super.key});
  @override
  State<QuickstartPage> createState() => _QuickstartPageState();
}

class _QuickstartPageState extends State<QuickstartPage> {
  final ErgBleManager _bleManager = ErgBleManager();
  AppState _state = AppState.idle;
  StreamSubscription<ErgometerConnectionState>? _connection;
  double? _workDistance;

  @override
  void initState() {
    super.initState();
    _initBle();
  }

  /// Ask once for permissions before init
  Future<void> _initBle() async {
    final perms = [
      Permission.location, // Android: BLE scan needs location
      if (Platform.isAndroid) Permission.bluetoothScan,
      if (Platform.isAndroid) Permission.bluetoothConnect,
      if (Platform.isIOS) Permission.bluetooth, // iOS
    ];
    final statuses = await perms.request();
    if (!statuses.values.every((s) => s.isGranted)) {
      setState(() => _state = AppState.permissionDenied);
      return;
    }
  }

  Future<void> _startBleFlow() async {
    setState(() => _state = AppState.scanning);

    // Scan, take first ergometer
    final erg = await _bleManager.startErgScan().first;

    // Connect & discover
    _connection = erg.connectAndDiscover().listen((state) {
      switch (state) {
        case ErgometerConnectionState.connected:
          setState(() => _state = AppState.connected);
          break;
        case ErgometerConnectionState.connecting:
          setState(() => _state = AppState.connecting);
          break;
        case ErgometerConnectionState.disconnected:
          _workDistance = null;
          setState(() => _state = AppState.idle);
          break;
      }
    });
    // Wait for workout summary
    final summary = await erg.monitorForData({Keys.ELAPSED_DISTANCE_KEY}).first;
    _workDistance = await summary[Keys.ELAPSED_DISTANCE_KEY];

    setState(() => _state = AppState.done);
  }

  void _disconnectBle() {
    _connection?.cancel();
    setState(() {
      _state = AppState.idle;
      _workDistance = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    String message;
    String hint;
    VoidCallback? action;
    IconData icon;

    switch (_state) {
      case AppState.idle:
        message = 'Disconnected';
        action = _startBleFlow;
        icon = Icons.bluetooth_searching;
        hint = 'Tap button to start scanning';
        break;
      case AppState.permissionDenied:
        message = 'Permissions denied';
        action = null;
        icon = Icons.block;
        hint = 'Restart app and grant them';
        break;
      case AppState.scanning:
        message = 'Scanning…';
        action = null;
        icon = Icons.wifi_tethering;
        hint = 'Scanning for the first erg around';
        break;
      case AppState.connecting:
        message = 'Connecting…';
        action = null;
        icon = Icons.bluetooth_connected;
        hint = 'Wait a second';
        break;
      case AppState.connected:
        message = 'Connected';
        action = _disconnectBle;
        icon = Icons.link_off;
        hint = 'You can try a rowing session or disconnect at any time';
        break;
      case AppState.done:
        message = '🏁 Done! Distance: ${_workDistance}';
        action = null;
        icon = Icons.flag;
        hint = 'This data was recovered from the ergometer subscription';
        break;
    }

    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('c2bluetooth example'))),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              width: 150.0,
              height: 150.0,
            ),
          ),
          Expanded(
              flex: 3,
              child: Container(
                  child: Column(
                children: [
                  Center(
                      child: Text(message,
                          style: TextStyle(fontSize: 50),
                          textAlign: TextAlign.center)),
                  Center(child: Text(hint, textAlign: TextAlign.center)),
                ],
              ))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: action,
        child: Icon(icon),
      ),
    );
  }
}

enum AppState { idle, permissionDenied, scanning, connecting, connected, done }
