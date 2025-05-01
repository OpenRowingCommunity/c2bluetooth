import 'dart:async';
import 'dart:io';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:c2bluetooth/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SimpleErgView(),
    );
  }
}

class SimpleErgView extends StatefulWidget {
  @override
  _SimpleErgViewState createState() => _SimpleErgViewState();
}

class _SimpleErgViewState extends State<SimpleErgView> {
  String displayText = "_";
  String displayText2 = "_";
  String displayText3 = "_";

  ErgBleManager bleManager = ErgBleManager();

  Ergometer? targetDevice;
  StreamSubscription<Ergometer>? scanSub;

  /// Storing the connection [StreamSubscription].
  /// Call cancel() to disconnect the device
  StreamSubscription<ErgometerConnectionState>? _ergConnection;

  /// Using [ValueNotifier] to handle app states
  ValueNotifier<ErgometerConnectionState> ergStateNotifier =
      ValueNotifier(ErgometerConnectionState.disconnected);
  ValueNotifier<String> messageNotifier = ValueNotifier("Welcome");
  @override
  void initState() {
    super.initState();
    handlePermissions();
  }

  Future<Map<Permission, PermissionStatus>> handlePermissions() {
    return [
      if (Platform.isAndroid) Permission.bluetoothConnect,
      if (Platform.isAndroid) Permission.bluetoothScan,
      if (Platform.isIOS) Permission.bluetooth,
      Permission.location,
    ].request().then((result) {
      if (result.containsValue(PermissionStatus.denied)) {
        print('Your device is experiencing a permission issue. $result');
        messageNotifier.value = "Insufficient permissions: Stopped";
      }
      return result;
    });
  }

  startScan() async {
    messageNotifier.value = "Scanning...";

    scanSub = bleManager.startErgScan().handleError((error) {
      print('Your device is experiencing a bluetooth issue. ${error.message}');
      messageNotifier.value = "Scanning Issue: Stopped";
    }).listen((erg) {
      //Scan one peripheral and stop scanning
      print("Scanned Peripheral ${erg.name}");
      stopScan();
      setState(() {
        targetDevice = erg;
      });
      messageNotifier.value = "Found ${erg.name}";
    });
  }

  stopScan() {
    scanSub?.cancel();
    scanSub = null;
  }

  connectToDevice() async {
    if (targetDevice == null) {
      messageNotifier.value = "No Device Selected";
      ergStateNotifier.value = ErgometerConnectionState.disconnected;
      return;
    }
    ergStateNotifier.value = ErgometerConnectionState.connecting;
    messageNotifier.value = "Device Connecting";

    _ergConnection =
        targetDevice!.connectAndDiscover().listen((connectionStatus) {
      switch (connectionStatus) {
        case ErgometerConnectionState.connected:
          messageNotifier.value = "device: ${targetDevice!.name}";
          subscribeToStreams();
        case ErgometerConnectionState.disconnected:
          targetDevice = null;
          messageNotifier.value = "Disconnected";
          break;
        default:
      }
      ergStateNotifier.value = connectionStatus;
    });
  }

  setup2kH() async {
    if (targetDevice == null) return;

    // ignore: deprecated_member_use
    targetDevice?.configure2kWorkout();
  }

  setup10kH() async {
    if (targetDevice == null) return;

    // ignore: deprecated_member_use
    targetDevice?.configure10kWorkout();
  }

  setup2k() async {
    if (targetDevice == null) return;

    targetDevice?.configureWorkout(Workout.single(WorkoutGoal.meters(2000)));
  }

  setup10k() async {
    if (targetDevice == null) return;

    targetDevice?.configureWorkout(Workout.single(WorkoutGoal.meters(10000)));
  }

  subscribeToStreams() async {
    if (targetDevice == null) return;

    // ignore: deprecated_member_use
    targetDevice!.monitorForWorkoutSummary().listen((summary) {
      print(summary);
      //TODO: update this for futures
      summary.workDistance.then((dist) {
        setState(() {
          displayText = "distance: $dist";
        });
      });
      summary.timestamp.then((time) {
        setState(() {
          displayText2 = "datetime: $time";
        });
      });
      summary.avgSPM.then((spm) {
        setState(() {
          displayText3 = "sr: $spm";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("c2bluetooth example")),
      ),
      body: Column(children: [
        Expanded(
          flex: 2,
          child: workoutSummary(),
        ),
        Expanded(
          flex: 2,
          child: configureWorkout(),
        ),
        Expanded(
          flex: 1,
          child: manageDevice(),
        ),
      ]),
    );
  }

  Row manageDevice() {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Column(
              children: [
                Spacer(),
                ValueListenableBuilder<ErgometerConnectionState>(
                    valueListenable: ergStateNotifier,
                    builder: (context, state, child) {
                      switch (state) {
                        case ErgometerConnectionState.connected:
                          return ElevatedButton(
                            onPressed: () {
                              // Cancel StreamSubscription to disconnect targetDevice
                              _ergConnection?.cancel().then((_) {
                                targetDevice = null; // reset targetDevice
                                ergStateNotifier.value = ErgometerConnectionState
                                    .disconnected; // change state to disconnected
                                messageNotifier.value = 'Disconnected';
                              });
                            },
                            child: Text("Disconnect"),
                          );
                        case ErgometerConnectionState.connecting:
                          return ElevatedButton(
                            onPressed: () {},
                            child: Text("Connecting..."),
                          );

                        default:
                          return ElevatedButton(
                            onPressed: () {
                              targetDevice == null
                                  ? startScan()
                                  : connectToDevice();
                            },
                            child: targetDevice == null
                                ? Text("Start Scan")
                                : Text('Start Pairing'),
                          );
                      }
                    }),
                Spacer(),
                Center(
                  child: ValueListenableBuilder(
                      valueListenable: messageNotifier,
                      builder: (context, message, child) {
                        return Text(
                          message,
                          style:
                              TextStyle(fontSize: 18, color: Colors.blueGrey),
                        );
                      }),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row configureWorkout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Center(
                child: TextButton(
                    onPressed: setup2kH,
                    child: Text("Configure a 2k (hardcoded)")),
              ),
              Center(
                child: TextButton(
                    onPressed: setup10kH,
                    child: Text("Configure a 10k (hardcoded)")),
              ),
              Center(
                child: TextButton(
                    onPressed: setup2k, child: Text("Configure a 2k")),
              ),
              Center(
                child: TextButton(
                    onPressed: setup10k, child: Text("Configure a 10k")),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row workoutSummary() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Center(
                child: Text(
                  displayText,
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
              Center(
                child: Text(
                  displayText2,
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
              Center(
                child: Text(
                  displayText3,
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // disable subscription on scan and ergometer ble connection
    stopScan();
    _ergConnection?.cancel().then((_) => _ergConnection = null);
    bleManager
        .destroy(); //remember to release native resources when you're done!
    super.dispose();
  }
}
