import 'dart:typed_data';

import 'package:c2bluetooth/c2bluetooth.dart';
import '../src/commands.dart';
import '../src/datatypes.dart';
import 'package:csafe_fitness/csafe_fitness.dart';
import '../helpers.dart';
import '../../src/dataplex.dart';
import 'workout.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'package:rxdart/rxdart.dart';

enum ErgometerConnectionState { connecting, connected, disconnected }

class Ergometer {
  Peripheral _peripheral;
  Csafe? _csafeClient;

  Dataplex _dataplex = new Dataplex();

  /// Get the name of this erg. i.e. "PM5" + serial number
  ///
  /// Returns "Unknown" if the erg does not report a name
  String get name => _peripheral.name ?? "Unknown";

  /// Create an Ergometer from a FlutterBleLib peripheral object
  ///
  /// This is mainly intended for internal use
  Ergometer(this._peripheral);

  /// Connect to this erg and discover the services and characteristics that it offers
  Future<void> connectAndDiscover() async {
    await _peripheral.connect();
    await _peripheral.discoverAllServicesAndCharacteristics();

    _csafeClient = Csafe(_readCsafe, _writeCsafe);
  }

  /// Disconnect from this erg or cancel the connection
  Future<void> disconnectOrCancel() async {
    return _peripheral.disconnectOrCancelConnection();
  }

  Stream<Map<String, dynamic>> monitorForData(
      Set<String> datapointIdentifiers) {
    return _dataplex.createStream(datapointIdentifiers);
  }

  /// Returns a stream of [WorkoutSummary] objects upon completion of any programmed piece or a "just row" piece that is longer than 1 minute.
  @Deprecated("This API is being deprecated soon")
  Stream<WorkoutSummary> monitorForWorkoutSummary() {
    Stream<Uint8List> ws1 = _peripheral
        .monitorCharacteristic(Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
            Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID)
        .asyncMap((datapoint) => datapoint.read());

    Stream<Uint8List> ws2 = _peripheral
        .monitorCharacteristic(Identifiers.C2_ROWING_PRIMARY_SERVICE_UUID,
            Identifiers.C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC2_UUID)
        .asyncMap((datapoint) => datapoint.read());

    return Rx.zip2(ws1, ws2, (Uint8List ws1Result, Uint8List ws2Result) {
      List<int> combinedList = ws1Result.toList();
      combinedList.addAll(ws2Result.toList());
      return WorkoutSummary.fromBytes(Uint8List.fromList(combinedList));
    });
  }

  /// Expose a stream of events to enable monitoring the erg's connection state
  /// This acts as a wrapper around the state provided by the internal bluetooth library to aid with swapping it out later.
  Stream<ErgometerConnectionState> monitorConnectionState() {
    return _peripheral.observeConnectionState().asyncMap((connectionState) {
      switch (connectionState) {
        case PeripheralConnectionState.connecting:
          return ErgometerConnectionState.connecting;
        case PeripheralConnectionState.connected:
          return ErgometerConnectionState.connected;
        case PeripheralConnectionState.disconnecting:
          return ErgometerConnectionState.disconnected;
        case PeripheralConnectionState.disconnected:
          return ErgometerConnectionState.disconnected;
        default:
          return ErgometerConnectionState.disconnected;
      }
    });
  }

  /// A read function for the PM over bluetooth.
  ///
  /// Intended for passing to the csafe_fitness library to allow it to read data from the erg
  Stream<Uint8List> _readCsafe() {
    return _peripheral
        .monitorCharacteristic(Identifiers.C2_ROWING_CONTROL_SERVICE_UUID,
            Identifiers.C2_ROWING_PM_TRANSMIT_CHARACTERISTIC_UUID)
        .asyncMap((datapoint) {
      print("reading data: ${datapoint.value}");
      return datapoint.value;
    });
  }

  /// A write function for the PM over bluetooth.
  ///
  /// Intended for passing to the csafe_fitness library to allow it to write data to the erg
  Future<Characteristic> _writeCsafe(Uint8List value) {
    return _peripheral.writeCharacteristic(
        Identifiers.C2_ROWING_CONTROL_SERVICE_UUID,
        Identifiers.C2_ROWING_PM_RECEIVE_CHARACTERISTIC_UUID,
        value,
        true);
    //.asyncMap((datapoint) => datapoint.read());
  }

  @Deprecated("This is a temporary function for development/experimentation and will be gone very soon")
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

  @Deprecated(
      "This is a temporary function for development/experimentation and will be gone very soon")
  void configure10kWorkout() async {
    //(CSAFE_SETPROGRAM_CMD, standard list workout #1)
    await _csafeClient!.sendCommands([
      CsafeCmdSetProgram(Uint8List.fromList([0x03, 0x00]).asCsafe())
    ]).then((value) => print(value));
    await _csafeClient!
        .sendCommands([cmdGoInUse]).then((value) => print(value));
  }

  /// Program a workout into the PM with particular parameters
  ///
  ///Currently only the more basic of workout types are supported, such as basic single intervals, single distance, and single time pieces
  void configureWorkout(Workout workout, [bool startImmediately = true]) async {
    //Workout workout

    List<WorkoutType> unimplementedWorkouts = [
      WorkoutType.JUSTROW_NOSPLITS,
      WorkoutType.JUSTROW_SPLITS,
      WorkoutType.FIXED_WATTMINUTES,
      WorkoutType.FIXED_CALORIE,
      WorkoutType.FIXEDCALS_INTERVAL,
      WorkoutType.VARIABLE_INTERVAL,
      WorkoutType.VARIABLE_UNDEFINEDREST_INTERVAL
    ];
    if (unimplementedWorkouts.contains(workout.getC2WorkoutType())) {
      throw new FormatException(
          "The workout type ${workout.getC2WorkoutType()} is not yet supported");
    }

    bool shouldUseC2ProprietaryAPI = workout.isInterval ||
        workout.goalTypes.contains(DurationType.CALORIES) ||
        workout.goalTypes.contains(DurationType.WATTMIN);

    if (shouldUseC2ProprietaryAPI) {
      _configureProprietaryWorkout(
          workout, startImmediately = startImmediately);
      return;
    }

    List<CsafeCommand> commands = [];
    //at this point there should be one and only one goal defined
    if (workout.goals.first.type == DurationType.DISTANCE) {
      //for fixed distance workouts
      commands.add(
          CsafeCmdSetHorizontalGoal(workout.goals.first.asCsafeDistance()));
    } else if (workout.goals.first.type == DurationType.TIME) {
      // fixed time workouts
      commands
          .add(CsafeCmdSetTimeGoal(workout.goals.first.asDuration().asCsafe()));
    }

    if (workout.hasSplits) {
      commands
          .add(CsafeCmdUserCfg1(CsafePMSetSplitDuration(workout.splitLength!)));
    }

    if (workout.targetPacePer500 != null) {
      commands.add(CsafeCmdSetPower(CsafeIntegerWithUnits(
          splitToWatts(workout.targetPacePer500!), CsafeUnits.watts)));
    }

    commands.add(CsafeCmdSetProgram(Concept2WorkoutPreset.programmed()));

    await _csafeClient!.sendCommands(commands).then((value) => print(value));

    if (startImmediately) {
      _startWorkout();
    }
  }

  void _startWorkout() async {
    await _csafeClient!
        .sendCommands([cmdGoInUse]).then((value) => print(value));
  }

  void _startWorkoutProprietary() async {
    await _csafeClient!.sendCommands([
      C2ProprietaryWrapper(
          [CsafePMSetScreenState(WorkoutScreenValue.PREPARETOROWWORKOUT)])
    ]).then((value) => print(value));
  }

  void _configureProprietaryWorkout(Workout workout,
      [bool startImmediately = true]) async {
    List<Concept2Command> commands = [];

    commands.add(CsafePMSetWorkoutType(workout.getC2WorkoutType()));

    if (workout.isInterval) {
      // for each interval
      commands.add(CsafePmSetWorkoutDuration(workout.goals.first.toC2()));
      commands.add(CsafePmSetWorkoutDuration(workout.rests.first.toC2()));
    } else {
      // if (workout.goals.first.type == DurationType.CALORIES) {
      //   commands.add(CsafePmSetWorkoutDuration(workout.goals.first.))
      // } else if (workout.goals.first.type == DurationType.WATTMIN) {}
    }

    if (workout.hasSplits) {
      commands.add(CsafePMSetSplitDuration(workout.splitLength!));
    }

    await _sendProprietaryCommands(commands);

    if (startImmediately) {
      _startWorkoutProprietary();
    }
  }

  Future<List<CsafeCommandResponse>> _sendProprietaryCommands(
      List<Concept2Command> commands) async {
    // wrap each command in an individual proprietary wrapper so that its more likely to fit within the 20 byte limit for messages sent to and from the Erg.
    return _csafeClient!
        .sendCommands(commands.map((e) => C2ProprietaryWrapper([e])).toList());
    // .then((value) => print(value));
  }
}
