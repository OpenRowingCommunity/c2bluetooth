import 'dart:typed_data';
import 'package:c2bluetooth/csafe/datatypes.dart';
import 'package:csafe_fitness/csafe_fitness.dart';
import 'package:csafe_fitness/commands.dart';
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
class CsafePMSetSplitDuration extends Concept2Command {
  CsafePMSetSplitDuration(Concept2IntegerWithUnits duration)
      : super.long(0x05, 5, duration) {
    validateData(duration, [validateC2SplitGoal()], shouldThrow: true);
  }
}

class CsafePMSetScreenState extends Concept2Command {
  CsafePMSetScreenState(ByteSerializable data) : super.long(0x13, 2, data) {
    validateData(
        data, [validateType<Concept2IntegerWithUnits>(), validateC2SplitGoal()],
        shouldThrow: true);
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
