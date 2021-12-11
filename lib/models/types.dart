/// This library defines the enum types specified in the Concept2 Bluetooth spec
///
/// All of these enum types have extentions on them that add an additional `value` getter. In most cases this is equal to the index of that enum value, but sometimes it is used to specify a different value (like c-style enums allow you to do) in order to stay consistent with the C2 spec.
/// The values from this `value` getter should NOT be used as an index and are intended for mapping between the values returned by the erg and their respective enumerations
/// The extension also offers a `fromInt()` function that returns the enum whose value matches the provided integer. This is intended to be used when parsing these values from the bytes that are provided by the erg.
library types;

enum MachineType {
  ERGMACHINE_TYPE_STATIC_D,
  ERGMACHINE_TYPE_STATIC_C,
  ERGMACHINE_TYPE_STATIC_A,
  ERGMACHINE_TYPE_STATIC_B,
  ERGMACHINE_TYPE_STATIC_E, // = 5,
  ERGMACHINE_TYPE_STATIC_SIMULATOR, // = 7,
  ERGMACHINE_TYPE_STATIC_DYNAMIC, // = 8,
  ERGMACHINE_TYPE_SLIDES_A, // = 16,
  ERGMACHINE_TYPE_SLIDES_B,
  ERGMACHINE_TYPE_SLIDES_C,
  ERGMACHINE_TYPE_SLIDES_D,
  ERGMACHINE_TYPE_SLIDES_E,
  ERGMACHINE_TYPE_SLIDES_DYNAMIC, // = 32,
  ERGMACHINE_TYPE_STATIC_DYNO, // = 64,
  ERGMACHINE_TYPE_STATIC_SKI, // = 128,
  ERGMACHINE_TYPE_STATIC_SKI_SIMULATOR, //143
  ERGMACHINE_TYPE_BIKE, // = 192,
  ERGMACHINE_TYPE_BIKE_ARMS,
  ERGMACHINE_TYPE_BIKE_NOARMS,
  ERGMACHINE_TYPE_BIKE_SIMULATOR, // = 207,
  ERGMACHINE_TYPE_MULTIERG_ROW, // = 224,
  ERGMACHINE_TYPE_MULTIERG_SKI, //225
  ERGMACHINE_TYPE_MULTIERG_BIKE, //226
  ERGMACHINE_TYPE_NUM
}

extension MachineTypeValueExtension on MachineType {
  int get value {
    switch (this) {
      case MachineType.ERGMACHINE_TYPE_STATIC_D:
      case MachineType.ERGMACHINE_TYPE_STATIC_C:
      case MachineType.ERGMACHINE_TYPE_STATIC_A:
      case MachineType.ERGMACHINE_TYPE_STATIC_B:
        return this.index;
      case MachineType.ERGMACHINE_TYPE_STATIC_E:
        return 5;
      case MachineType.ERGMACHINE_TYPE_STATIC_SIMULATOR:
        return 7;
      case MachineType.ERGMACHINE_TYPE_STATIC_DYNAMIC:
        return 8;
      case MachineType.ERGMACHINE_TYPE_SLIDES_A:
        return 16;
      case MachineType.ERGMACHINE_TYPE_SLIDES_B:
        return 17;
      case MachineType.ERGMACHINE_TYPE_SLIDES_C:
        return 18;
      case MachineType.ERGMACHINE_TYPE_SLIDES_D:
        return 19;
      case MachineType.ERGMACHINE_TYPE_SLIDES_E:
        return 20;
      case MachineType.ERGMACHINE_TYPE_SLIDES_DYNAMIC:
        return 32;
      case MachineType.ERGMACHINE_TYPE_STATIC_DYNO:
        return 64;
      case MachineType.ERGMACHINE_TYPE_STATIC_SKI:
        return 128;
      case MachineType.ERGMACHINE_TYPE_STATIC_SKI_SIMULATOR:
        return 143;
      case MachineType.ERGMACHINE_TYPE_BIKE:
        return 192;
      case MachineType.ERGMACHINE_TYPE_BIKE_ARMS:
        return 193;
      case MachineType.ERGMACHINE_TYPE_BIKE_NOARMS:
        return 194;
      case MachineType.ERGMACHINE_TYPE_BIKE_SIMULATOR:
        return 207;
      case MachineType.ERGMACHINE_TYPE_MULTIERG_ROW:
        return 224;
      case MachineType.ERGMACHINE_TYPE_MULTIERG_SKI:
        return 225;
      case MachineType.ERGMACHINE_TYPE_MULTIERG_BIKE:
        return 226;
      case MachineType.ERGMACHINE_TYPE_NUM:
        return 227;
    }
  }

  MachineType fromInt(int i) {
    switch (i) {
      case 0:
        return MachineType.ERGMACHINE_TYPE_STATIC_D;
      case 1:
        return MachineType.ERGMACHINE_TYPE_STATIC_C;
      case 2:
        return MachineType.ERGMACHINE_TYPE_STATIC_A;
      case 3:
        return MachineType.ERGMACHINE_TYPE_STATIC_B;
      case 5:
        return MachineType.ERGMACHINE_TYPE_STATIC_E;
      case 7:
        return MachineType.ERGMACHINE_TYPE_STATIC_SIMULATOR;
      case 8:
        return MachineType.ERGMACHINE_TYPE_STATIC_DYNAMIC;
      case 16:
        return MachineType.ERGMACHINE_TYPE_SLIDES_A;
      case 17:
        return MachineType.ERGMACHINE_TYPE_SLIDES_B;
      case 18:
        return MachineType.ERGMACHINE_TYPE_SLIDES_C;
      case 19:
        return MachineType.ERGMACHINE_TYPE_SLIDES_D;
      case 20:
        return MachineType.ERGMACHINE_TYPE_SLIDES_E;
      case 32:
        return MachineType.ERGMACHINE_TYPE_SLIDES_DYNAMIC;
      case 64:
        return MachineType.ERGMACHINE_TYPE_STATIC_DYNO;
      case 128:
        return MachineType.ERGMACHINE_TYPE_STATIC_SKI;
      case 143:
        return MachineType.ERGMACHINE_TYPE_STATIC_SKI_SIMULATOR;
      case 192:
        return MachineType.ERGMACHINE_TYPE_BIKE;
      case 193:
        return MachineType.ERGMACHINE_TYPE_BIKE_ARMS;
      case 194:
        return MachineType.ERGMACHINE_TYPE_BIKE_NOARMS;
      case 207:
        return MachineType.ERGMACHINE_TYPE_BIKE_SIMULATOR;
      case 224:
        return MachineType.ERGMACHINE_TYPE_MULTIERG_ROW;
      case 225:
        return MachineType.ERGMACHINE_TYPE_MULTIERG_SKI;
      case 226:
        return MachineType.ERGMACHINE_TYPE_MULTIERG_BIKE;
      case 227:
        return MachineType.ERGMACHINE_TYPE_NUM;
      default:
        throw new FormatException("value $i has no matching MachineType");
    }
  }
}

enum WorkoutType {
  WORKOUTTYPE_JUSTROW_NOSPLITS,
  WORKOUTTYPE_JUSTROW_SPLITS,
  WORKOUTTYPE_FIXEDDIST_NOSPLITS,
  WORKOUTTYPE_FIXEDDIST_SPLITS,
  WORKOUTTYPE_FIXEDTIME_NOSPLITS,
  WORKOUTTYPE_FIXEDTIME_SPLITS,
  WORKOUTTYPE_FIXEDTIME_INTERVAL,
  WORKOUTTYPE_FIXEDDIST_INTERVAL,
  WORKOUTTYPE_VARIABLE_INTERVAL,
  WORKOUTTYPE_VARIABLE_UNDEFINEDREST_INTERVAL,
  WORKOUTTYPE_FIXED_CALORIE,
  WORKOUTTYPE_FIXED_WATTMINUTES,
  WORKOUTTYPE_FIXEDCALS_INTERVAL,
  WORKOUTTYPE_NUM
}

extension WorkoutTypeValueExtension on WorkoutType {
  int get value => this.index;

  WorkoutType fromInt(int i) => WorkoutType.values[i];
}

enum WorkoutState {
  WORKOUTSTATE_WAITTOBEGIN,
  WORKOUTSTATE_WORKOUTROW,
  WORKOUTSTATE_COUNTDOWNPAUSE,
  WORKOUTSTATE_INTERVALREST,
  WORKOUTSTATE_INTERVALWORKTIME,
  WORKOUTSTATE_INTERVALWORKDISTANCE,
  WORKOUTSTATE_INTERVALRESTENDTOWORKTIME,
  WORKOUTSTATE_INTERVALRESTENDTOWORKDISTANCE,
  WORKOUTSTATE_INTERVALWORKTIMETOREST,
  WORKOUTSTATE_INTERVALWORKDISTANCETOREST,
  WORKOUTSTATE_WORKOUTEND,
  WORKOUTSTATE_TERMINATE,
  WORKOUTSTATE_WORKOUTLOGGED,
  WORKOUTSTATE_REARM,
}

extension WorkoutStateValueExtension on WorkoutState {
  int get value => this.index;
  WorkoutState fromInt(int i) => WorkoutState.values[i];
}

enum IntervalType {
  INTERVALTYPE_TIME,
  INTERVALTYPE_DIST,
  INTERVALTYPE_REST,
  INTERVALTYPE_TIMERESTUNDEFINED,
  INTERVALTYPE_DISTANCERESTUNDEFINED,
  INTERVALTYPE_RESTUNDEFINED,
  INTERVALTYPE_CAL,
  INTERVALTYPE_CALRESTUNDEFINED,
  INTERVALTYPE_WATTMINUTE,
  INTERVALTYPE_WATTMINUTERESTUNDEFINED,
  INTERVALTYPE_NONE //overridden to 255 with the extenstion below

}

extension IntervalTypeExtension on IntervalType {
  int get value {
    if (this == IntervalType.INTERVALTYPE_NONE) {
      return 255;
    }
    return this.index;
  }

  IntervalType fromInt(int i) {
    if (i == 255) {
      return IntervalType.INTERVALTYPE_NONE;
    }
    return IntervalType.values[i];
  }
}

enum RowingState {
  ROWINGSTATE_INACTIVE,
  ROWINGSTATE_ACTIVE,
}

extension RowingStateValueExtension on RowingState {
  int get value => this.index;
  RowingState fromInt(int i) => RowingState.values[i];
}

enum StrokeState {
  STROKESTATE_WAITING_FOR_WHEEL_TO_REACH_MIN_SPEED_STATE,
  STROKESTATE_WAITING_FOR_WHEEL_TO_ACCELERATE_STATE,
  STROKESTATE_DRIVING_STATE,
  STROKESTATE_DWELLING_AFTER_DRIVE_STATE,
  STROKESTATE_RECOVERY_STATE
}

extension StrokeStateValueExtension on StrokeState {
  int get value => this.index;
  StrokeState fromInt(int i) => StrokeState.values[i];
}

enum GameId {
  APGLOBALS_GAMEID_NONE,
  APGLOBALS_GAMEID_FISH,
  APGLOBALS_GAMEID_DART,
  APGLOBALS_GAMEID_TARGET_BASIC,
  APGLOBALS_GAMEID_TARGET_ADVANCED,
  APGLOBALS_GAMEID_CROSSTRAINING
}

extension GameIdValueExtension on GameId {
  int get value => this.index;
  GameId fromInt(int i) => GameId.values[i];
}
