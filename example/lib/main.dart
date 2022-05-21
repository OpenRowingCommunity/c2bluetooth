import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:c2bluetooth/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

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
      home: SimpleErgView(storage: CounterStorage()),
    );
  }
}

class CounterStorage {
  String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    print(directory!.path);
    return directory.path;
    // "/storage/emulated/0/Documents";
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    String filepath = '$path/ergmultiplexdata-$now.txt';
    print(filepath);
    return File(filepath);
  }

  // Future<int> readCounter() async {
  //   try {
  //     final file = await _localFile;

  //     // Read the file
  //     final contents = await file.readAsString();

  //     return int.parse(contents);
  //   } catch (e) {
  //     // If encountering an error, return 0
  //     return 0;
  //   }
  // }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;

    var contents;
    //     // Read the file
    try {
      contents = await file.readAsString();
      print("file contents:");

      print(contents);
    } catch (e) {
      print("no file contents:");

      contents = "";
    }

    // Write the file
    return file.writeAsString(contents + counter);
  }
}

class SimpleErgView extends StatefulWidget {
  const SimpleErgView({super.key, required this.storage});

  final CounterStorage storage;

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
    bleManager.init(); //ready to go!

    startScan();
  }

  startScan() {
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
    widget.storage.writeCounter("setting up 10k\n");
    if (targetDevice == null) return;

    targetDevice?.configureWorkout(Workout.single(WorkoutGoal.meters(10000)));
  }

  listenForMultiplex() async {
    if (targetDevice == null) return;

    targetDevice?.monitorForMultiplex().listen((data) {
      widget.storage.writeCounter(data.toList().toString() + "\n");
    });
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
      setState(() {
        displayText = "distance: ${summary.workDistance}";
        displayText2 = "datetime: ${summary.timestamp}";
        displayText3 = "sr: ${summary.avgSPM}";
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
        Center(
          child: TextButton(
              onPressed: listenForMultiplex,
              child: Text("Listen for multiplex data")),
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
