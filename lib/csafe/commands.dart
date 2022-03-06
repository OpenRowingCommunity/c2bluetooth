import 'package:c2bluetooth/csafe/datatypes.dart';
import 'package:csafe_fitness/csafe_fitness.dart';
import 'package:csafe_fitness/commands.dart';
import 'validators.dart';

/// a list of Csafe Commands for concept2

class CsafePMSetSplitDuration extends CsafeCommand {
  CsafePMSetSplitDuration(Concept2IntegerWithUnits duration)
      : super.long(0x05, 5, duration) {
    validateData(duration, [validateC2SplitGoal()], shouldThrow: true);
  }
}
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
