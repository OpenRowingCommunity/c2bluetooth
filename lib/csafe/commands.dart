import 'package:c2bluetooth/csafe/datatypes.dart';
import 'package:csafe_fitness/csafe_fitness.dart';
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
