import 'dart:typed_data';

import 'package:c2bluetooth/csafe/commands.dart';
import 'package:c2bluetooth/csafe/datatypes.dart';
import 'package:csafe_fitness/csafe_fitness.dart';
import 'workoutsummary.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'package:rxdart/rxdart.dart';

class Ergometer {
  Peripheral? _peripheral;
  Csafe? _csafeClient;

  /// Get the name (i.e. "PM5 " + serial number) of this erg.
  ///
  /// Returns "unknown" if the erg does not report a name
  String get name => _peripheral?.name ?? "Unknown";

  /// Create an Ergometer from a FlutterBleLib peripheral object
  ///
  /// This is mainly intended for internal use
  Ergometer.fromPeripheral(Peripheral peripheral) {
    // TODO: make me private somehow
    this._peripheral = peripheral;
  }

  /// Connect to this erg and discover the services and characteristics that it offers
  Future<void> connectAndDiscover() async {
    if (_peripheral == null) return;

    await _peripheral!.connect();
    await _peripheral!.discoverAllServicesAndCharacteristics();

    _csafeClient = Csafe(_readCsafe, _writeCsafe);
  }

  // Disconnect from this erg or cancel the connection
  Future<void> disconnectOrCancel() async {
    if (_peripheral == null) return;

    return _peripheral?.disconnectOrCancelConnection();
  }

  /// Returns a stream of [WorkoutSummary] objects upon completion of any programmed piece or a "just row" piece that is longer than 1 minute.
  Stream<WorkoutSummary> monitorForWorkoutSummary() {
    Stream<Uint8List> ws1 = _peripheral!
        .monitorCharacteristic(Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
            Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID)
        .asyncMap((datapoint) => datapoint.read());

    Stream<Uint8List> ws2 = _peripheral!
        .monitorCharacteristic(Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
            Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC2_UUID)
        .asyncMap((datapoint) => datapoint.read());

    return Rx.zip2(ws1, ws2, (Uint8List ws1Result, Uint8List ws2Result) {
      List<int> combinedList = ws1Result.toList();
      combinedList.addAll(ws2Result.toList());
      return WorkoutSummary.fromBytes(Uint8List.fromList(combinedList));
    });
  }

  Stream<Uint8List> _readCsafe() {
    return _peripheral!
        .monitorCharacteristic(Identifiers.C2_ROWING_CONTROL_SERVICE_UUID,
            Identifiers.C2_ROWING_PM_TRANSMIT_CHARACTERISTIC_UUID)
        .asyncMap((datapoint) {
      print("reading data: ${datapoint.value}");
      return datapoint.value;
    });
  }

  Future<Characteristic> _writeCsafe(Uint8List value) {
    return _peripheral!.writeCharacteristic(
        Identifiers.C2_ROWING_CONTROL_SERVICE_UUID,
        Identifiers.C2_ROWING_PM_RECEIVE_CHARACTERISTIC_UUID,
        value,
        true);
    //.asyncMap((datapoint) => datapoint.read());
  }

  void configure2kWorkout() async {
    //Workout workout
    await _csafeClient!.sendCommands([
      CsafeCmdSetHorizontal(CsafeIntegerWithUnits.kilometers(2))
    ]).then((value) => print(value));
//(CSAFE_SETUSERCFG1_CMD, CSAFE_PM_SET_SPLITDURATION, distance, 500m)
    await _csafeClient!.sendCommands([
      CsafeCmdUserCfg1(
          Uint8List.fromList([0x05, 0x05, 0x80, 0xF4, 0x01, 0x00, 0x00])
              .asCsafe())
    ]).then((value) => print(value));

    await _csafeClient!.sendCommands([
      CsafeCmdSetPower(CsafeIntegerWithUnits.watts(300))
    ]).then((value) => print(value));

    //(CSAFE_SETPROGRAM_CMD, programmed workout)
    await _csafeClient!.sendCommands([
      CsafeCmdSetProgram(Uint8List.fromList([0x00, 0x00]).asCsafe())
    ]).then((value) => print(value));

    await _csafeClient!
        .sendCommands([cmdGoInUse]).then((value) => print(value));
  }

  void configure10kWorkout() async {
    //(CSAFE_SETPROGRAM_CMD, standard list workout #1)
    await _csafeClient!.sendCommands([
      CsafeCmdSetProgram(Uint8List.fromList([0x03, 0x00]).asCsafe())
    ]).then((value) => print(value));
    await _csafeClient!
        .sendCommands([cmdGoInUse]).then((value) => print(value));
  }

  void configureWorkout(int distance, [bool startImmediately = true]) async {
    //Workout workout
    await _csafeClient!.sendCommands([
      CsafeCmdSetHorizontal(CsafeIntegerWithUnits.meters(distance)),
//(CSAFE_SETUSERCFG1_CMD, CSAFE_PM_SET_SPLITDURATION, distance, 500m)
      CsafeCmdUserCfg1(
          CsafePMSetSplitDuration(Concept2IntegerWithUnits.distance(500))),
      CsafeCmdSetPower(CsafeIntegerWithUnits.watts(300)),

      //(CSAFE_SETPROGRAM_CMD, programmed workout)
      CsafeCmdSetProgram(Concept2WorkoutPreset.programmed())
    ]).then((value) => print(value));

    if (startImmediately) {
      _startWorkout();
    }
  }

  void _startWorkout() async {
    await _csafeClient!
        .sendCommands([cmdGoInUse]).then((value) => print(value));
  }
}
