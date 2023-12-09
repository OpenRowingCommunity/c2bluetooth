import 'dart:async';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:c2bluetooth/models/workout.dart';
import 'package:flutter/material.dart';

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
  String displayText = "hi";
  String displayText2 = "hi";
  String displayText3 = "hi";

  ErgBleManager bleManager = ErgBleManager();

  Ergometer? targetDevice;
  StreamSubscription<Ergometer>? scanSub;

  @override
  void initState() {
    super.initState();
    unawaited(
      bleManager.init().then((_) => startScan()),
    );
  }

  Future<void> startScan() async {
    setState(() {
      displayText = "Start Scanning";
    });

    scanSub = bleManager.startErgScan().listen((erg) {
      //Scan one peripheral and stop scanning
      print("Scanned Peripheral ${erg.name}");

      stopScan();
      targetDevice = erg;
      connectToDevice();
    });
  }

  stopScan() {
    scanSub?.cancel();
    scanSub = null;
    bleManager.stopErgScan();
  }

  connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      displayText = "Device Connecting";
    });

    await targetDevice!.connectAndDiscover();

    // if (!connected) {
    //   targetDevice!
    //       .observeConnectionState(
    //           emitCurrentValue: true, completeOnDisconnect: true)
    //       .listen((connectionState) {
    //     print(
    //         "Peripheral ${targetDevice!.name} connection state is $connectionState");
    //   });
    //   try {
    //     await targetDevice!.connect();
    //   } catch (BleError) {
    //     print("a");
    //   }
    //   print('CONNECTING');
    // } else {
    //   print('DEVICE Already CONNECTED');
    // }
    // setState(() {
    //   displayText = "Device Connected";
    // });
    // discoverServices();
    subscribeToStreams();
  }

  setup2kH() async {
    if (targetDevice == null) return;

    targetDevice?.configure2kWorkout();
  }

  setup10kH() async {
    if (targetDevice == null) return;

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

  disconnectFromDevice() async {
    if (targetDevice == null) return;

    // targetDevice!.disconnect();
    await targetDevice?.disconnectOrCancel();

    setState(() {
      displayText = "Device Disconnected";
    });
  }

  subscribeToStreams() async {
    if (targetDevice == null) return;

    setState(() {
      displayText = "Setting up streams";
    });

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
        title: Text("hello"),
      ),
      body: Column(children: [
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
        Center(
          child: TextButton(
              onPressed: setup2kH, child: Text("Configure a 2k (hardcoded)")),
        ),
        Center(
          child: TextButton(
              onPressed: setup10kH, child: Text("Configure a 10k (hardcoded)")),
        ),
        Center(
          child: TextButton(onPressed: setup2k, child: Text("Configure a 2k")),
        ),
        Center(
          child:
              TextButton(onPressed: setup10k, child: Text("Configure a 10k")),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    disconnectFromDevice();
    bleManager
        .destroy(); //remember to release native resources when you're done!
    super.dispose();
  }
}
