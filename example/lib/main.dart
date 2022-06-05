import 'dart:async';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:c2bluetooth/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:fresh_example/widgets.dart';

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
      home: FindDevicesView(),
    );
  }
}

class FindDevicesView extends StatelessWidget {
  // final ErgBleManager? bleManager;

  const FindDevicesView({Key? key}) : super(key: key);

  Future<void> refresh() async {
    StreamSubscription<List<Ergometer>> str =
        ErgBleManager().scanResultStream.listen((event) {
      print(event);
    });
    return await Future.delayed(Duration(seconds: 5), str.cancel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<Ergometer>>(
                  stream: ErgBleManager().scanResultStream,
                  initialData: [],
                  builder: (c, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!
                            .map(
                              (r) => ScanResultTile(
                                result: r,
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  r.connectAndDiscover();
                                  return SimpleErgView(erg: r);
                                })),
                              ),
                            )
                            .toList(),
                      );
                    } else {
                      return FloatingActionButton(
                          child: Icon(Icons.search),
                          onPressed: () => refresh());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}




  const SimpleErgView({Key? key, required this.erg}) : super(key: key);

  setup2kH() async {
    if (erg == null) return;

    erg?.configure2kWorkout();
  }

  setup10kH() async {
    if (erg == null) return;

    erg?.configure10kWorkout();
  }

  setup2k() async {
    if (erg == null) return;

    erg?.configureWorkout(Workout.single(WorkoutGoal.meters(2000)));
  }

  setup10k() async {
    if (erg == null) return;

    erg?.configureWorkout(Workout.single(WorkoutGoal.meters(10000)));
  }

  // disconnectFromDevice() async {
  //   if (erg == null) return;

  //   // erg!.disconnect();
  //   await erg?.disconnectOrCancel();


  subscribeToStreams() async {
    if (erg == null) return;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 24, color: Colors.blue);

    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: Column(children: [
        StreamBuilder<WorkoutSummary>(
          stream: erg?.monitorForWorkoutSummary(),
          builder: (c, snapshot) => Column(children: [
            Center(
              child: Text(
                "distance: ${snapshot.data?.workDistance}",
                style: textStyle,
              ),
            ),
            Center(
              child: Text(
                "datetime: ${snapshot.data?.workTime}",
                style: textStyle,
              ),
            ),
            Center(
              child: Text(
                "avg sr: ${snapshot.data?.avgSPM}",
                style: textStyle,
              ),
            )
          ]),
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
