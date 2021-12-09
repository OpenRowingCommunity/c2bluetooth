# c2bluetooth

A flutter package designed to sit on top of [FlutterBleLib](https://github.com/dotintent/FlutterBleLib) and provide an easy API for accessing data from Concept2 PM5 Indoor rowing machines. This library implements the [Concept2 Performance Monitor Bluetooth Smart Communications Interface Definition](https://www.concept2.com/files/pdf/us/monitors/PM5_BluetoothSmartInterfaceDefinition.pdf) Specification.

## Roadmap

Currently the library only supports retrieving simple workout summary information from the erg (date and time of workout, duration of workout, distance, average strokes per minute) after the conclusion of a workout. More features beyond that are currently planned.

## Usage
TBD

## Unit Testing
Tests can be run with `flutter test` or `flutter test --coverage` for coverage information.

Generate a HTML coverage report with `genhtml coverage/lcov.info -o coverage/html` (may require installing something. see [here](https://stackoverflow.com/questions/50789578/how-can-the-code-coverage-data-from-flutter-tests-be-displayed)). This `coverage` directory is gitignored already.
