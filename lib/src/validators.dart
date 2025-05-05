import 'package:c2bluetooth/c2bluetooth.dart';
import '../src/datatypes.dart';
import 'package:csafe_fitness/csafe_fitness.dart';

//TODO: validate data as a big endian IntegerWithUnits-like type with DurationType as the unit
// maybe make a Concept2IntegerWithUnit subclass to handle this

Validator validateC2SplitGoal() {
  return validate(
      (data) =>
          (data is Concept2IntegerWithUnits) &&
          (data.unit == DurationType.DISTANCE ||
              data.unit == DurationType.TIME),
      (data) => ArgumentError(
          "Value provided must be in either a distance or a time unit"));
}
