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
  String displayText = "hi";
  String displayText2 = "hi";
  String displayText3 = "hi";

  ErgBleManager bleManager = ErgBleManager();

  Ergometer? targetDevice;
  StreamSubscription<Ergometer>? scanSub;

  @override
  void initState() {
    super.initState();
    //startScan();
  }

  startScan() async {
    await Future.wait<PermissionStatus>([
      Permission.location.request(),
      Permission.locationWhenInUse.request()
    ]).then((results) {
      PermissionStatus locationPermission = results[0];
      PermissionStatus finePermission = results[1];
      if (Platform.isAndroid) {
        if (locationPermission == PermissionStatus.granted &&
            finePermission == PermissionStatus.granted) {
          return true;
        }
      } else if (Platform.isIOS) {
        return true;
      }
      return false;
    }).then((result) {
      if (result) {
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
      } else {
        print(
            'Your device is experiencing a permission issue. Make sure you allow location services.');
        setState(() {
          displayText = "Permission Issue Stopped Scanning";
        });
      }
    });
  }

  stopScan() {
    scanSub?.cancel();
    scanSub = null;
  }

  connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      displayText = "Device Connecting";
    });

    targetDevice!.connectAndDiscover().listen((event) {
      if (event == ErgometerConnectionState.connected) {
        subscribeToStreams();
      }
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

    setState(() {
      displayText = "Setting up streams";
    });

    targetDevice!.monitorForData({
      Keys.ELAPSED_DISTANCE_KEY,
      Keys.WORKOUT_TIMESTAMP_KEY,
      Keys.WORKOUT_AVG_SPM_KEY
    }).listen((data) {
      print(data);

      setState(() {
        displayText = "distance: ${data[Keys.ELAPSED_DISTANCE_KEY]}";
        displayText2 = "datetime: ${data[Keys.WORKOUT_TIMESTAMP_KEY]}";
        displayText3 = "sr: ${data[Keys.WORKOUT_AVG_SPM_KEY]}";
      });
    });

    targetDevice!.monitorForData({
      Keys.SEGMENT_NUMBER_KEY,
      Keys.SEGMENT_DISTANCE_KEY,
      Keys.SEGMENT_AVG_SPM_KEY,
      Keys.ELAPSED_DISTANCE_KEY
    }).listen((data) {
      print(data);

      setState(() {
        displayText = "interval #: ${data[Keys.SEGMENT_NUMBER_KEY]}";
        displayText2 =
            "sd: ${data[Keys.SEGMENT_DISTANCE_KEY]}, gd:  ${data[Keys.ELAPSED_DISTANCE_KEY]}";
        displayText3 = "sr avg: ${data[Keys.SEGMENT_AVG_SPM_KEY]}";
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
        Visibility(
          visible: scanSub == null && targetDevice == null,
          child: ElevatedButton(
            onPressed: () {
              startScan();
            },
            child: Text("Start Scan"),
          ),
        ),
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
    //disconnectFromDevice();
    bleManager
        .destroy(); //remember to release native resources when you're done!
    super.dispose();
  }
}
