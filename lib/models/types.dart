/// This library defines the enum types specified in the Concept2 Bluetooth spec
///
/// All of these enum types have extentions on them that add an additional `value` getter. In most cases this is equal to the index of that enum value, but sometimes it is used to specify a different value (like c-style enums allow you to do) in order to stay consistent with the C2 spec.
/// The values from this `value` getter should NOT be used as an index and are intended for mapping between the values returned by the erg and their respective enumerations
/// The extension also offers a `fromInt()` function that returns the enum whose value matches the provided integer. This is intended to be used when parsing these values from the bytes that are provided by the erg.
library types;

enum MachineType {
  STATIC_D,
  STATIC_C,
  STATIC_A,
  STATIC_B,
  STATIC_E, // = 5,
  STATIC_SIMULATOR, // = 7,
  STATIC_DYNAMIC, // = 8,
  SLIDES_A, // = 16,
  SLIDES_B,
  SLIDES_C,
  SLIDES_D,
  SLIDES_E,
  SLIDES_DYNAMIC, // = 32,
  STATIC_DYNO, // = 64,
  STATIC_SKI, // = 128,
  STATIC_SKI_SIMULATOR, //143
  BIKE, // = 192,
  BIKE_ARMS,
  BIKE_NOARMS,
  BIKE_SIMULATOR, // = 207,
  MULTIERG_ROW, // = 224,
  MULTIERG_SKI, //225
  MULTIERG_BIKE, //226
  NUM
}

extension MachineTypeExtension on MachineType {
  int get value {
    switch (this) {
      case MachineType.STATIC_D:
      case MachineType.STATIC_C:
      case MachineType.STATIC_A:
      case MachineType.STATIC_B:
        return this.index;
      case MachineType.STATIC_E:
        return 5;
      case MachineType.STATIC_SIMULATOR:
        return 7;
      case MachineType.STATIC_DYNAMIC:
        return 8;
      case MachineType.SLIDES_A:
        return 16;
      case MachineType.SLIDES_B:
        return 17;
      case MachineType.SLIDES_C:
        return 18;
      case MachineType.SLIDES_D:
        return 19;
      case MachineType.SLIDES_E:
        return 20;
      case MachineType.SLIDES_DYNAMIC:
        return 32;
      case MachineType.STATIC_DYNO:
        return 64;
      case MachineType.STATIC_SKI:
        return 128;
      case MachineType.STATIC_SKI_SIMULATOR:
        return 143;
      case MachineType.BIKE:
        return 192;
      case MachineType.BIKE_ARMS:
        return 193;
      case MachineType.BIKE_NOARMS:
        return 194;
      case MachineType.BIKE_SIMULATOR:
        return 207;
      case MachineType.MULTIERG_ROW:
        return 224;
      case MachineType.MULTIERG_SKI:
        return 225;
      case MachineType.MULTIERG_BIKE:
        return 226;
      case MachineType.NUM:
        return 227;
    }
  }

  static MachineType fromInt(int i) {
    switch (i) {
      case 0:
        return MachineType.STATIC_D;
      case 1:
        return MachineType.STATIC_C;
      case 2:
        return MachineType.STATIC_A;
      case 3:
        return MachineType.STATIC_B;
      case 5:
        return MachineType.STATIC_E;
      case 7:
        return MachineType.STATIC_SIMULATOR;
      case 8:
        return MachineType.STATIC_DYNAMIC;
      case 16:
        return MachineType.SLIDES_A;
      case 17:
        return MachineType.SLIDES_B;
      case 18:
        return MachineType.SLIDES_C;
      case 19:
        return MachineType.SLIDES_D;
      case 20:
        return MachineType.SLIDES_E;
      case 32:
        return MachineType.SLIDES_DYNAMIC;
      case 64:
        return MachineType.STATIC_DYNO;
      case 128:
        return MachineType.STATIC_SKI;
      case 143:
        return MachineType.STATIC_SKI_SIMULATOR;
      case 192:
        return MachineType.BIKE;
      case 193:
        return MachineType.BIKE_ARMS;
      case 194:
        return MachineType.BIKE_NOARMS;
      case 207:
        return MachineType.BIKE_SIMULATOR;
      case 224:
        return MachineType.MULTIERG_ROW;
      case 225:
        return MachineType.MULTIERG_SKI;
      case 226:
        return MachineType.MULTIERG_BIKE;
      case 227:
        return MachineType.NUM;
      default:
        throw new FormatException("value $i has no matching MachineType");
    }
  }
}

enum WorkoutType {
  JUSTROW_NOSPLITS,
  JUSTROW_SPLITS,
  FIXEDDIST_NOSPLITS,
  FIXEDDIST_SPLITS,
  FIXEDTIME_NOSPLITS,
  FIXEDTIME_SPLITS,
  FIXEDTIME_INTERVAL,
  FIXEDDIST_INTERVAL,
  VARIABLE_INTERVAL,
  VARIABLE_UNDEFINEDREST_INTERVAL,
  FIXED_CALORIE,
  FIXED_WATTMINUTES,
  FIXEDCALS_INTERVAL,
  NUM
}

extension WorkoutTypeExtension on WorkoutType {
  int get value => this.index;

  static WorkoutType fromInt(int i) => WorkoutType.values[i];
}

enum DurationType {
  TIME, // = 0,
  CALORIES, // = 0x40,
  DISTANCE, // = 0x80,
  WATTMIN, // = 0xC0
}

extension DurationTypeExtension on DurationType {
  int get value {
    switch (this) {
      case DurationType.TIME:
        return 0x00;
      case DurationType.DISTANCE:
        return 0x40;
      case DurationType.CALORIES:
        return 0x80;
      case DurationType.WATTMIN:
        return 0xC0;
    }
  }

  static DurationType fromInt(int i) {
    switch (i) {
      case 0x00:
        return DurationType.TIME;
      case 0x40:
        return DurationType.DISTANCE;
      case 0x80:
        return DurationType.CALORIES;
      case 0xC0:
        return DurationType.WATTMIN;
      default:
        throw new ArgumentError("value $i has no matching DurationType");
    }
  }
}

enum WorkoutState {
  WAITTOBEGIN,
  WORKOUTROW,
  COUNTDOWNPAUSE,
  INTERVALREST,
  INTERVALWORKTIME,
  INTERVALWORKDISTANCE,
  INTERVALRESTENDTOWORKTIME,
  INTERVALRESTENDTOWORKDISTANCE,
  INTERVALWORKTIMETOREST,
  INTERVALWORKDISTANCETOREST,
  WORKOUTEND,
  TERMINATE,
  WORKOUTLOGGED,
  REARM,
}

extension WorkoutStateExtension on WorkoutState {
  int get value => this.index;
  static WorkoutState fromInt(int i) => WorkoutState.values[i];
}

enum IntervalType {
  TIME,
  DIST,
  REST,
  TIMERESTUNDEFINED,
  DISTANCERESTUNDEFINED,
  RESTUNDEFINED,
  CAL,
  CALRESTUNDEFINED,
  WATTMINUTE,
  WATTMINUTERESTUNDEFINED,
  NONE //overridden to 255 with the extenstion below

}

extension IntervalTypeExtension on IntervalType {
  int get value {
    if (this == IntervalType.NONE) {
      return 255;
    }
    return this.index;
  }

  static IntervalType fromInt(int i) {
    if (i == 255) {
      return IntervalType.NONE;
    }
    return IntervalType.values[i];
  }
}

enum RowingState {
  ROWINGSTATE_INACTIVE,
  ROWINGSTATE_ACTIVE,
}

extension RowingStateExtension on RowingState {
  int get value => this.index;
  static RowingState fromInt(int i) => RowingState.values[i];
}

enum StrokeState {
  STROKESTATE_WAITING_FOR_WHEEL_TO_REACH_MIN_SPEED_STATE,
  STROKESTATE_WAITING_FOR_WHEEL_TO_ACCELERATE_STATE,
  STROKESTATE_DRIVING_STATE,
  STROKESTATE_DWELLING_AFTER_DRIVE_STATE,
  STROKESTATE_RECOVERY_STATE
}

extension StrokeStateExtension on StrokeState {
  int get value => this.index;
  static StrokeState fromInt(int i) => StrokeState.values[i];
}

enum GameId {
  APGLOBALS_GAMEID_NONE,
  APGLOBALS_GAMEID_FISH,
  APGLOBALS_GAMEID_DART,
  APGLOBALS_GAMEID_TARGET_BASIC,
  APGLOBALS_GAMEID_TARGET_ADVANCED,
  APGLOBALS_GAMEID_CROSSTRAINING
}

extension GameIdExtension on GameId {
  int get value => this.index;
  static GameId fromInt(int i) => GameId.values[i];
}
