import 'package:c2bluetooth/csafe/datatypes.dart';
import 'package:csafe_fitness/csafe_fitness.dart';

/// a list of Csafe Commands for concept2

class CsafePMSetSplitDuration extends CsafeCommand {
  CsafePMSetSplitDuration(ByteSerializable data) : super.long(0x05, 5, data) {
    validateData(data, [validateType<Concept2IntegerWithUnits>()],
        shouldThrow: true);
  }
}
