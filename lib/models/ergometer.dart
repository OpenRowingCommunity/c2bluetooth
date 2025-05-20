import 'dart:async';
import 'dart:typed_data';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:c2bluetooth/exceptions/c2bluetooth_exceptions.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:c2bluetooth/src/commands.dart';
import 'package:c2bluetooth/src/datatypes.dart';
import 'package:c2bluetooth/src/dataplex.dart';
import 'package:csafe_fitness/csafe_fitness.dart';
import 'package:c2bluetooth/helpers.dart';
import 'workout.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;

enum ErgometerConnectionState { connecting, connected, disconnected }

class Ergometer {
  final FlutterReactiveBle _flutterReactiveBle;
  DiscoveredDevice _peripheral;
  Csafe? _csafeClient;

  late final Dataplex _dataplex;

  /// Get the name of this erg. i.e. "PM5" + serial number
  String get name => _peripheral.name;
  Stream<ConnectionStateUpdate>? _connection;

  /// Create an [Ergometer] from a discovered bluetooth device object
  ///
  /// This is intended only for internal use by [ErgBleManager.startErgScan].
  /// Consider this method a private API that is subject to unannounced breaking
  /// changes. There are likely much better methods to use for whatever you are trying to do.
  Ergometer(this._peripheral, {required FlutterReactiveBle bleClient})
      : _flutterReactiveBle = bleClient;

  /// Connect to this erg and discover the services and characteristics that it offers
  /// this returns a stream of [ErgometerConnectionState] events to enable monitoring the erg's connection state and disconnecting.
  Stream<ErgometerConnectionState> connectAndDiscover() {
    //this may cause problems if the device goes out of range between scenning and trying to connect. maybe use connectToAdvertisingDevice instead to mitigate this and prevent a hang on android

    //if no services are specified in the `servicesWithCharacteristicsToDiscover` parameter, then full service discovery will be performed
    _connection = _flutterReactiveBle
        .connectToDevice(id: _peripheral.id)
        .handleError((error) =>
            throw C2ConnectionException('Error while connecting', error));
    _dataplex = new Dataplex(_peripheral, _flutterReactiveBle);
    _csafeClient = Csafe(_readCsafe, _writeCsafe);
    return getMonitorConnectionState;
  }

  /// Deprecation notice: disconnect does not exists on FlutterReactiveBle library
  @Deprecated("Destroy the Ergometer object to disconnect")
  void disconnectOrCancel() {
    throw NoSuchMethodError;
  }

  /// Subscribe to a stream of data from the erg
  ///  (ex: general.distance, stroke.drive_length, ...)
  Stream<Map<String, dynamic>> monitorForData(
      Set<String> datapointIdentifiers) {
    return _dataplex.createStream(datapointIdentifiers);
  }

  // Ensure compatibility
  @Deprecated("Use getMonitorConnectionState getter")
  Stream<ErgometerConnectionState> monitorConnectionState() {
    return getMonitorConnectionState;
  }

  /// Expose a stream of events to enable monitoring the erg's connection state
  /// This acts as a wrapper around the state provided by the internal bluetooth library to aid with swapping it out later.
  Stream<ErgometerConnectionState> get getMonitorConnectionState =>
      _connection!.asyncMap((connectionStateUpdate) {
        switch (connectionStateUpdate.connectionState) {
          case DeviceConnectionState.connecting:
            return ErgometerConnectionState.connecting;
          case DeviceConnectionState.connected:
            return ErgometerConnectionState.connected;
          case DeviceConnectionState.disconnecting:
            return ErgometerConnectionState.disconnected;
          default:
            return ErgometerConnectionState.disconnected;
        }
      });

  /// An internal read function for accessing the PM's CSAFE API over bluetooth.
  ///
  /// Intended for passing to the csafe_fitness library to allow it to read response data  from the erg
  Stream<Uint8List> _readCsafe() {
    var csafeRxCharacteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(Identifiers.C2_ROWING_CONTROL_SERVICE_UUID),
        characteristicId:
            Uuid.parse(Identifiers.C2_ROWING_PM_TRANSMIT_CHARACTERISTIC_UUID),
        deviceId: _peripheral.id);

    return _flutterReactiveBle
        .subscribeToCharacteristic(csafeRxCharacteristic)
        .asyncMap((datapoint) => Uint8List.fromList(datapoint))
        .asyncMap((datapoint) {
      print("reading data: $datapoint");
      return datapoint;
    });
  }

  /// An internal write function for accessing the PM's CSAFE API over bluetooth.
  ///
  /// Intended for passing to the csafe_fitness library to allow it to write commands to the erg
  void _writeCsafe(Uint8List value) {
    var csafeTxCharacteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(Identifiers.C2_ROWING_CONTROL_SERVICE_UUID),
        characteristicId:
            Uuid.parse(Identifiers.C2_ROWING_PM_RECEIVE_CHARACTERISTIC_UUID),
        deviceId: _peripheral.id);

    // return _peripheral.writeCharacteristic(
    //     Identifiers.C2_ROWING_CONTROL_SERVICE_UUID,
    //     Identifiers.C2_ROWING_PM_RECEIVE_CHARACTERISTIC_UUID,
    //     value,
    //     true);
    // //.asyncMap((datapoint) => datapoint.read());

    _flutterReactiveBle.writeCharacteristicWithResponse(csafeTxCharacteristic,
        value: value);
  }

  @Deprecated(
      "This is a temporary function for development/experimentation and will be gone very soon")
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
  /// Currently only the more basic of workout types are supported, such as basic single intervals, single distance, and single time pieces
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
