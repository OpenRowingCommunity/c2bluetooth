# c2bluetooth

[![Dart](https://github.com/CrewLAB/c2bluetooth/actions/workflows/dart.yml/badge.svg)](https://github.com/CrewLAB/c2bluetooth/actions/workflows/dart.yml)
[![Matrix](https://img.shields.io/matrix/c2bluetooth:matrix.org?label=chat%20on%20matrix)](https://matrix.to/#/#c2bluetooth:matrix.org)

C2Bluetooth is a flutter package designed to provide an easy API for accessing data from Concept2 PM5 Indoor fitness machines via bluetooth. This library implements the [Concept2 Performance Monitor Bluetooth Smart Communications Interface Definition](https://www.concept2.com/files/pdf/us/monitors/PM5_BluetoothSmartInterfaceDefinition.pdf) Specification ([newer versions](https://www.c2forum.com/viewtopic.php?f=15&t=193697#p527068) are also available). It also relies heavily on the [CSAFE specification](https://web.archive.org/web/20060718175014/http://www.fitlinxx.com/csafe/specification.htm) from FitLinxx.

## Demo
This package comes with a demo app in the `example/` directory.

See the [`example/README.md`](example/README.md) for more detailed information about the demo app and how to use it. 

## Key Library Features

Currently this library supports a few basic features such as:
- retrieving workout summary information from the erg after a workout
- programming a workout into the erg

In the future, we hope to add support for things like:
- Streaming data during a workout
- updating the time on the erg
- updating the erg firmware


## Documentation
The `docs` folder contains a few `.md` (markdown) files that are meant to help explain the major components of the library. Within this folder is also a `diagrams` folder that contains `draw.io/diagrams.net` files that also hope to provide some other ways to understand how this library works. The easiest way to see these diagrams besides looking at any exported copies embedded in the markdown files is to open them in diagrams.net wither online or using their desktop app.  

## Installation

To install this package, just like any other flutter package, it needs to be included in your pubspec.yaml. Here are some templates for doing so:

**Pub.dev version**
To install from pub.dev, run the command `flutter pub add c2bluetooth` or add the following to your dependencies in pubspec.yaml:
```
dependencies:
  c2bluetooth: ^1.0.0
```

Alternative installation methods for development can be found in [CONTRUBUTING.md](CONTRIBUTING.md)

## Usage
Similar to how the underlying bluetooth library works, pretty much everything begins with an instance of `ErgBleManager()`. For a complete example, see the [example app](example/)'s main.dart file. Below are some of the key steps

### Creating a manager

```dart
ErgBleManager bleManager = ErgBleManager();
```
### Scanning for devices
Next, you need to start scanning for available devices. This uses a Stream to return an instance of the `Ergometer` class for each erg found. Each of these instances represents an erg and should be stored for later reuse as these act as the base upon which everything else (retrieving data, sending workouts .etc) is based.

**Important:** Many of these setup steps will fail if bluetooth is off or if permissions are not correct. C2bluetooth leaves the responsibility of handling permissions up to applications implementing the library. This is mainly because different apps will want to handle the user experience of this differently.

```dart
Ergometer myErg;

StreamSubscription<Ergometer> ergScanStream = bleManager.startErgScan().listen((erg) {
	//your code for detecting an erg here.

  //you can store the erg instance somewhere
  myErg = erg;

  //or connect to it (see later examples)

  //or stop scanning
  ergScanStream.cancel();

  return erg;
});
```
This block of code is where you can do things like:
 - determine what erg(s) you want to work with (this can be based on name, user choice, or basicaly anything)
 - store the erg instance somewhere more permanent, like the `myErg` variable to allow you to be able to access it after you stop scanning.
 - cancel the stream if you are done scanning.


### Connecting and disconnecting
Once you have the `Ergometer` instance for the erg you want to connect to, you can call `connectAndDiscover()` on it to connect. This will provide you with a stream indicating the connection state of the erg.

```dart
StreamSubscription<Ergometer> ergConnectionStream = myErg.connectAndDiscover().listen((event) {
  if(event == ErgometerConnectionState.connected) {
    //do stuff here once the erg is connected
  } else if (event == ErgometerConnectionState.disconnected) {
    //handle disconnection here
  }
}, onError: (Object error) {
  // Handle a possible error
  if (error is C2ConnectionException) {
    //handle connection errors
  } else if (error is C2BluetoothException) {
    print("C2Bluetooth error: ${error.message}");
  } else {
    print("Unknown error: $error");
  }
});
```

When you are done, disconnect from your erg by cancelling the stream:
```dart
ergConnectionStream.cancel();
```

### Getting data from the erg
To get data from the erg, use one of the methods available in the `Ergometer` class as described below.

Concept2 offers various data via their Bluetooth interface which for our purposes are categorized as follows (from most to least granular):
- **General status data** think periodic snapshots of what the user sees on the monitor
- **Stroke data** a datapoint for each complete stroke taken [not yet implemented]
- **Interval or split data** a datapoint for each split or interval in the workout [not yet implemented]
- **Workout Summary data** data summarizing the entire workout after completion [not yet implemented]

When retrieving data, here are some things to keep in mind (based on information available in the Concept2 Bluetooth smart specification, rev 1.27):
- Bluetooth smart is a relatively low-bandwidth protocol. Under ideal conditions the maximum speed at which data can be received is about 1000 bytes per second for Android and about 640 bytes per second for iOS.
- iOS and Android have different limitations on various bluetooth parameters that affect things like bandwidth.
- Bluetooth is based on radio waves. Signal (and ultimately your bandwidth) can be impacted by things like other nearby bluetooth devices, physical obstacles, interference from other devices, and other things. 

#### General Status Data
To Be Implemented/Documented
#### Stroke Data
To Be Implemented/Documented
#### Interval or split data
To Be Implemented/Documented
#### Workout Summary data

Workout summary data can be `monitorForWorkoutSummary()`. This is a stream that returns a `WorkoutSummary` object that allows you to access the data from a completed workout (this includes programmed pieces as well as "Just row" pieces that are longer than 1 minute)

```dart
myErg.monitorForWorkoutSummary().listen((workoutSummary) {
  //do whatever here
});
```

Each workout summary is a flutter object that contains the following fields:
- `timestamp`
- `workTime`
- `workDistance`
- `avgSPM`
- `endHeartRate`
- `avgHeartRate`
- `minHeartRate`
- `maxHeartRate`
- `avgDragFactor`
- `recoveryHeartRate`
- `workoutType`
- `avgPace`
- `intervalType`
- `intervalSize`
- `intervalCount`
- `totalCalories`
- `watts`
- `totalRestDistance`
- `intervalRestTime`
- `avgCalories`

The `recoveryHeartRate` field is one that the erg sends after the rower has been resting for 1 minute. If the workout is cancelled or the erg is turned off before the end of this minute, the data may never arrive. See #10. This is likely to change later if a better solution is found. See #11.



## Community Projects
This is a list of projects built using c2Bluetooth. If you find or make something that is not on this list, send us a pull request!

- [CrewLAB app](https://www.crewlab.io/) (proprietary license)

## Contributing
If you are interested in making contributions to this library, please check out the [CONTRIBUTING](CONTRIBUTING.md) document, or learn how c2bluetooth works in the [API](docs/API.md) document

## Support and Licensing

![The crewLAB logo](docs/images/crewlablogo.png)


This library was created for the rowing community with support and feedback from [CrewLAB](https://www.crewlab.io/).

This library is licensed in a way that can be used within proprietary apps, as long as any changes you or your company make to this library are released and publicly accessible. Full legal details are available in the [LICENSE](./LICENSE) file.
