import 'dart:typed_data';
import './datatypes.dart';
import 'package:c2bluetooth/enums.dart';
import 'package:csafe_fitness/csafe_fitness.dart';
import 'validators.dart';

///Represents a command that was created by Concept2
///
///This class is mainly intended to help organize the concept2 commands so that they can be referred to as a group within commands like [C2ProprietaryWrapper]
class Concept2Command extends CsafeCommand {
  //Passthrough to CsafeCommand since constructors arent inherited
  Concept2Command.long(int commandId, int? byteCount, ByteSerializable data)
      : super.long(commandId, byteCount, data);

  ///Creates a special case for "wrapper" commands that can contain other commands
  ///
  ///these wrapper commands dont really have a set length. Instead, the length is just set to the length of the data they contain.
  Concept2Command.wrapper(int commandId, ByteSerializable data)
      : super.long(commandId, data.byteLength, data);

  //Passthrough to CsafeCommand since constructors arent inherited
  Concept2Command.short(int commandId) : super.short(commandId);
}

///Represents Concept2's proprietary wrapper commands
///
///Concept2 technically has four of these with identifiers 0x76 0x77 0x7E and 0x7F, but based on their spec it seems as though there arent really any restrictions on what commands each can be used for, making them basically all interchangeable.
class C2ProprietaryWrapper extends Concept2Command {
  C2ProprietaryWrapper(List<Concept2Command> commands)
      : super.wrapper(
            0x76,
            commands
                .map((e) => e.toBytes())
                .reduce((data1, data2) =>
                    Uint8List.fromList(data1.toList() + data2.toList()))
                .asCsafe()) {
    // validateData(duration, [validateC2SplitGoal()], shouldThrow: true);
  }
}

class CsafePMSetSplitDuration extends Concept2Command {
  CsafePMSetSplitDuration(Concept2IntegerWithUnits duration)
      : super.long(0x05, 5, duration) {
    validateData(duration, [validateC2SplitGoal()], shouldThrow: true);
  }
}

class CsafePmSetWorkoutDuration extends Concept2Command {
  CsafePmSetWorkoutDuration(Concept2IntegerWithUnits duration)
      : super.long(0x03, 5, duration);
}

class CsafePMSetScreenState extends Concept2Command {
  // TODO: Expand this to cover more than just one kind of screen
  //Currently this just supports Workout screen types only for simplicity. in future this should accept any screen type
  CsafePMSetScreenState(WorkoutScreenValue screen)
      : super.long(
            0x13,
            2,
            Uint8List.fromList([ScreenType.WORKOUT.value, screen.value])
                .asCsafe()) {
    // validateData(
    //     data, [validateType<Concept2IntegerWithUnits>(), validateC2SplitGoal()],
    //     shouldThrow: true);
  }
}

class CsafePMSetWorkoutType extends Concept2Command {
  CsafePMSetWorkoutType(WorkoutType workoutType)
      : super.long(0x01, 1, workoutType.value.toBytes().asCsafe()) {
    // validateData(
    //     data, [validateType<Concept2IntegerWithUnits>(), validateC2SplitGoal()],
    //     shouldThrow: true);
  }
}

class CsafePMConfigureWorkout extends Concept2Command {
  CsafePMConfigureWorkout(WorkoutNumber workoutNum)
      : super.long(0x01, 1, workoutNum.value.toBytes(fillBytes: 1).asCsafe()) {
    // validateData(
    //     data, [validateType<Concept2IntegerWithUnits>(), validateC2SplitGoal()],
    //     shouldThrow: true);
  }
}

class CsafePMSetWorkoutIntervalCount extends Concept2Command {
  CsafePMSetWorkoutIntervalCount(int intervalCount)
      : super.long(0x18, 1, intervalCount.toBytes(fillBytes: 1).asCsafe()) {
    // validateData(
    //     data, [validateType<Concept2IntegerWithUnits>(), validateC2SplitGoal()],
    //     shouldThrow: true);
  }
}

class CsafePMSetIntervalType extends Concept2Command {
  CsafePMSetIntervalType(IntervalType intervalType)
      : super.long(
            0x17, 1, intervalType.value.toBytes(fillBytes: 1).asCsafe()) {
    // validateData(
    //     data, [validateType<Concept2IntegerWithUnits>(), validateC2SplitGoal()],
    //     shouldThrow: true);
  }
}

/// A CSAFE command to set a horizontal distance goal
///
/// This extends upon the Csafe version of the command in order to add checks for Concept2-specified limits.
/// According to Concept2, distance goals must be between 100m (inclusive) and 50000 (exclusive).
///
/// The maximum hoziontal distance for a BikeErg is 100,000m. This is not currently accounted for
class CsafeCmdSetHorizontalGoal extends CsafeCmdSetHorizontal {
  CsafeCmdSetHorizontalGoal(CsafeIntegerWithUnits data) : super(data);
}

/// A CSAFE command to set a workout time goal
///
/// This extends upon the Csafe version of the command in order to add checks for Concept2-specified limits.
/// According to Concept2, time goals must be between 20 seconds  (inclusive) and 10 hours (exclusive).
class CsafeCmdSetTimeGoal extends CsafeCmdSetTime {
  static const _TEN_HOURS_IN_SECONDS = Duration.secondsPerHour * 10;
  CsafeCmdSetTimeGoal(ByteSerializable data) : super(data) {
    //if we are at this point, the superclass validators should have already run to confirm we have a valid time value
    validateData(data, [validateTimeValue(20, _TEN_HOURS_IN_SECONDS)],
        shouldThrow: true);
  }
}
