import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';

import 'package:c2bluetooth/enums.dart';
// import 'package:csafe_fitness/src/types/enumtypes.dart';

/// Represents an integer with units as used within concept2-specific commands.
///
/// Concept2 seems to represent this data type differently within their own commands than CSAFE does with theirs by storing the number as a big endian number and transmitting the unit first.
class Concept2IntegerWithUnits extends IntegerWithUnits<DurationType> {
  Concept2IntegerWithUnits(value, unit, {int byteLength = 5})
      : super(value, unit, byteLength);

  Concept2IntegerWithUnits.fromBytes(Uint8List bytes,
      {Endian inputEndian = Endian.big})
      : super(
            CsafeIntExtension.fromBytes(bytes.sublist(1), endian: inputEndian),
            DurationTypeExtension.fromInt(bytes.first),
            bytes.length);

  //TODO: are there better names for these that indicate the actual unit, like meters or seconds watts/min
  Concept2IntegerWithUnits.distance(int value)
      : this(value, DurationType.DISTANCE);

  Concept2IntegerWithUnits.wattMinutes(int value)
      : this(value, DurationType.WATTMIN);

  Concept2IntegerWithUnits.calories(int value)
      : this(value, DurationType.CALORIES);

  Concept2IntegerWithUnits.time(int value) : this(value, DurationType.TIME);

  bool matchesType(DurationType type) => unit == type;

  @override
  Uint8List toBytes() {
    //, endian: Endian.big
    return Uint8List.fromList([unit.value] +
        value.toBytes(fillBytes: byteLength - 1, endian: Endian.big));
  }
}

class Concept2WorkoutPreset extends ByteSerializable {
  WorkoutNumber workoutNum;

  /// How many workouts are in each list
  static const _ITEMS_PER_GROUP = 5;

  Concept2WorkoutPreset(this.workoutNum);

  /// A general purpose private function for looking up workout numbers based on something closer to "favorites list workout #3"
  Concept2WorkoutPreset._fromList(int entryNumber, int groupOffset)
      : workoutNum = WorkoutNumberExtension.fromInt(
            entryNumber + groupOffset * _ITEMS_PER_GROUP) {
    if (entryNumber < 1 || entryNumber > 5) {
      throw ArgumentError(
          "entryNumber must be a value from 1-5 (inclusive) when using this workout list shortcut methods");
    }
  }
  Concept2WorkoutPreset.programmed()
      : workoutNum = WorkoutNumberExtension.fromInt(0);

  Concept2WorkoutPreset.fromStandardList(int entryNumber)
      : this._fromList(entryNumber, 0);

  Concept2WorkoutPreset.fromCustomList(int entryNumber)
      : this._fromList(entryNumber, 1);

  Concept2WorkoutPreset.fromFavorites(int entryNumber)
      : this._fromList(entryNumber, 2);

  @override
  Uint8List toBytes() {
    return Uint8List.fromList([workoutNum.index, 0x0]);
  }
}
