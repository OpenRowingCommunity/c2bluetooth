# c2bluetooth

A flutter package designed to sit on top of [FlutterBleLib](https://github.com/dotintent/FlutterBleLib) and provide an easy API for accessing data from Concept2 PM5 Indoor rowing machines. This library implements the [Concept2 Performance Monitor Bluetooth Smart Communications Interface Definition](https://www.concept2.com/files/pdf/us/monitors/PM5_BluetoothSmartInterfaceDefinition.pdf) Specification.

## Roadmap

Currently the library only supports retrieving simple workout summary information from the erg (date and time of workout, duration of workout, distance, average strokes per minute) after the conclusion of a workout. More features beyond that are currently planned.

## Installation

To install this package, just like any other flutter package, it needs to be included in your pubspec.yaml. Here are some templates for doing so:

**Pub.dev version**
To install from pub.dev, use the following snippet:

[Snippet TBD - Package not yet published.]

**From git**

To install as a [git dependency](https://dart.dev/tools/pub/dependencies#git-packages), use the following snippet:

```yaml
  c2bluetooth:
    git:
      url: git@github.com:CrewLab/c2bluetooth.git
      ref: v0.1.0
```

In this example, the value of the `ref` setting determines what branch/tag/commit it will use. this is useful if you want to lock your install to a particular version. If you want to use the bleeding-edge version, set this to `main`.

*Note*: This snippet assumes you have git configured correctly to be able to access the repository over SSH and have the correct auth (i.e. ssh keys) to access it without typing in your credentials. See the [dart docs](https://dart.dev/tools/pub/dependencies#git-packages) for more information 

**Locally**
For the most bleeding-edge experience - or if you plan to make and test changes to this library in realtime, it is recommended that you clone the library and use a relative path dependency as shown:

```yaml
  c2bluetooth:
    path: ../c2bluetooth
```
## Usage
TBD

## Unit Testing
Tests can be run with `flutter test` or `flutter test --coverage` for coverage information.

Generate a HTML coverage report with `genhtml coverage/lcov.info -o coverage/html` (may require installing something. see [here](https://stackoverflow.com/questions/50789578/how-can-the-code-coverage-data-from-flutter-tests-be-displayed)). This `coverage` directory is gitignored already.
