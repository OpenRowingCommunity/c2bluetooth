/// This file contains enum types specified by concept2's specification (generally located in the Appendix Section).
///
/// Because of how many there are in recent (0.13+) revisions of the spec and how long this file is already, this file tends towards adding enums as they are needed, rather than trying to add them all at once.
///
/// All of these enum types have extentions on them that add an additional `value` getter. In most cases this is equal to the index of that enum value, but sometimes it is used to specify a different value (like c-style enums allow you to do) in order to match the values provided by the C2 spec.
/// The values from this `value` getter (or the associated `fromInt` method) should only be used to convert to or from values being comunicated with a Concept2 PM. This whole thing is essentially a workaround because Dart's enums don't natively support custom values like most other languages (see: https://stackoverflow.com/questions/38908285/add-methods-or-values-to-enum-in-dart#58552304)

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
  static Map _machineTypeValues = {
    MachineType.STATIC_D: 0,
    MachineType.STATIC_C: 1,
    MachineType.STATIC_A: 2,
    MachineType.STATIC_B: 3,
    MachineType.STATIC_E: 5,
    MachineType.STATIC_SIMULATOR: 7,
    MachineType.STATIC_DYNAMIC: 8,
    MachineType.SLIDES_A: 16,
    MachineType.SLIDES_B: 17,
    MachineType.SLIDES_C: 18,
    MachineType.SLIDES_D: 19,
    MachineType.SLIDES_E: 20,
    MachineType.SLIDES_DYNAMIC: 32,
    MachineType.STATIC_DYNO: 64,
    MachineType.STATIC_SKI: 128,
    MachineType.STATIC_SKI_SIMULATOR: 143,
    MachineType.BIKE: 192,
    MachineType.BIKE_ARMS: 193,
    MachineType.BIKE_NOARMS: 194,
    MachineType.BIKE_SIMULATOR: 207,
    MachineType.MULTIERG_ROW: 224,
    MachineType.MULTIERG_SKI: 225,
    MachineType.MULTIERG_BIKE: 226,
    MachineType.NUM: 227
  };

  int get value => _machineTypeValues[this];
  static MachineType fromInt(int i) {
    MachineType? type =
        _machineTypeValues.map((key, value) => MapEntry(value, key))[i];
    if (type == null) {
      throw new ArgumentError("value $i has no matching MachineType");
    } else {
      return type;
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
  TIME, // = 0, 0.01 sec LSB
  CALORIES, // = 0x40, 1 cal LSB
  DISTANCE, // = 0x80, 1 meter LSB
  WATTMIN, // = 0xC0,
}

extension DurationTypeExtension on DurationType {
  static Map _durationTypes = {
    DurationType.TIME: 0x00,
    DurationType.CALORIES: 0x40,
    DurationType.DISTANCE: 0x80,
    DurationType.WATTMIN: 0xC0,
  };

  int get value => _durationTypes[this];
  static DurationType fromInt(int i) {
    DurationType? type =
        _durationTypes.map((key, value) => MapEntry(value, key))[i];
    if (type == null) {
      throw new ArgumentError("value $i has no matching DurationType");
    } else {
      return type;
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
  INACTIVE,
  ACTIVE,
}

extension RowingStateExtension on RowingState {
  int get value => this.index;
  static RowingState fromInt(int i) => RowingState.values[i];
}

enum StrokeState {
  WAITING_FOR_WHEEL_TO_REACH_MIN_SPEED_STATE,
  WAITING_FOR_WHEEL_TO_ACCELERATE_STATE,
  DRIVING_STATE,
  DWELLING_AFTER_DRIVE_STATE,
  RECOVERY_STATE
}

extension StrokeStateExtension on StrokeState {
  int get value => this.index;
  static StrokeState fromInt(int i) => StrokeState.values[i];
}

enum WorkoutNumber {
  PROGRAMMED,
  DEFAULT_1, //Standard list 1
  DEFAULT_2,
  DEFAULT_3,
  DEFAULT_4,
  DEFAULT_5, // standard list 5
  CUSTOM_1, //custom list 1
  CUSTOM_2,
  CUSTOM_3,
  CUSTOM_4,
  CUSTOM_5, //custom list 5
  MSD_1, //favorites 1
  MSD_2,
  MSD_3,
  MSD_4,
  MSD_5, //favorites 5
  NUM
}

extension WorkoutNumberExtension on WorkoutNumber {
  int get value => this.index;

  static WorkoutNumber fromInt(int i) => WorkoutNumber.values[i];
}

enum GameId { NONE, FISH, DART, TARGET_BASIC, TARGET_ADVANCED, CROSSTRAINING }

extension GameIdExtension on GameId {
  int get value => this.index;
  static GameId fromInt(int i) => GameId.values[i];
}

enum ScreenType {
  NONE,
  WORKOUT,
  RACE,
  CSAFE,
  DIAG,
  MFG,
}

extension ScreenTypeExtension on ScreenType {
  int get value => this.index;
  static ScreenType fromInt(int i) => ScreenType.values[i];
}

enum WorkoutScreenValue {
  NONE,

  /// None value (0).
  PREPARETOROWWORKOUT,

  /// Prepare to workout type (1).
  TERMINATEWORKOUT,

  /// Terminate workout type (2).
  REARMWORKOUT,

  /// Rearm workout type (3).
  REFRESHLOGCARD,

  /// Refresh local copies of logcard structures(4).
  PREPARETORACESTART,

  /// Prepare to race start (5).
  GOTOMAINSCREEN,

  /// Goto to main screen (6).
  LOGCARDBUSYWARNING,

  /// Log device busy warning (7).
  LOGCARDSELECTUSER,

  /// Log device select user (8).
  RESETRACEPARAMS,

  /// Reset race parameters (9).
  CABLETESTSLAVE,

  /// Cable test slave indication(10).
  FISHGAME,

  /// Fish game (11).
  DISPLAYPARTICIPANTINFO,

  /// Display participant info (12).
  DISPLAYPARTICIPANTINFOCONFIRM,

  /// Display participant info w/ confirmation  (13).
  CHANGEDISPLAYTYPETARGET,

  /// Display type set to target (20).
  CHANGEDISPLAYTYPESTANDARD,

  /// Display type set to standard (21).
  CHANGEDISPLAYTYPEFORCEVELOCITY,

  /// Display type set to forcevelocity (22).
  CHANGEDISPLAYTYPEPACEBOAT,

  /// Display type set to Paceboat (23).
  CHANGEDISPLAYTYPEPERSTROKE,

  /// Display type set to perstroke (24).
  CHANGEDISPLAYTYPESIMPLE,

  /// Display type set to simple (25).
  CHANGEUNITSTYPETIMEMETERS,

  /// Units type set to timemeters (30).
  CHANGEUNITSTYPEPACE,

  /// Units type set to pace (31).
  CHANGEUNITSTYPEWATTS,

  /// Units type set to watts (32).
  CHANGEUNITSTYPECALORICBURNRATE,

  /// Units type set to caloric burn rate(33).
  TARGETGAMEBASIC,

  /// Gasic target game (34).
  TARGETGAMEADVANCED,

  /// Advanced target game (35).
  DARTGAME,

  /// Dart game (36).
  GOTOUSBWAITREADY,

  /// USB wait ready (37).
  TACHCABLETESTDISABLE,

  /// Tach cable test disable (38).
  TACHSIMDISABLE,

  /// Tach simulator disable (39).
  TACHSIMENABLERATE1,

  /// Tach simulator enable, rate = 1:12 (40).
  TACHSIMENABLERATE2,

  /// Tach simulator enable, rate = 1:35 (41).
  TACHSIMENABLERATE3,

  /// Tach simulator enable, rate = 1:42 (42).
  TACHSIMENABLERATE4,

  /// Tach simulator enable, rate = 3:04 (43).
  TACHSIMENABLERATE5,

  /// Tach simulator enable, rate = 3:14 (44).
  TACHCABLETESTENABLE,

  /// Tach cable test enable (45).
  CHANGEUNITSTYPECALORIES,

  /// Units type set to calories(46).
  VIRTUALKEY_A,

  /// Virtual key select A (47).
  VIRTUALKEY_B,

  /// Virtual key select B (48).
  VIRTUALKEY_C,

  /// Virtual key select C (49).
  VIRTUALKEY_D,
  VIRTUALKEY_E,
  VIRTUALKEY_UNITS,
  VIRTUALKEY_DISPLAY,
  VIRTUALKEY_MENU,
  TACHSIMENABLERATERANDOM,
  SCREENREDRAW
}

extension WorkoutScreenValueExtension on WorkoutScreenValue {
  static Map _racingScreenValues = {
    WorkoutScreenValue.NONE: 0,
    WorkoutScreenValue.PREPARETOROWWORKOUT: 1,
    WorkoutScreenValue.TERMINATEWORKOUT: 2,
    WorkoutScreenValue.REARMWORKOUT: 3,
    WorkoutScreenValue.REFRESHLOGCARD: 4,
    WorkoutScreenValue.PREPARETORACESTART: 5,
    WorkoutScreenValue.GOTOMAINSCREEN: 6,
    WorkoutScreenValue.LOGCARDBUSYWARNING: 7,
    WorkoutScreenValue.LOGCARDSELECTUSER: 8,
    WorkoutScreenValue.RESETRACEPARAMS: 9,
    WorkoutScreenValue.CABLETESTSLAVE: 10,
    WorkoutScreenValue.FISHGAME: 11,
    WorkoutScreenValue.DISPLAYPARTICIPANTINFO: 12,
    WorkoutScreenValue.DISPLAYPARTICIPANTINFOCONFIRM: 13,
    WorkoutScreenValue.CHANGEDISPLAYTYPETARGET: 20,
    WorkoutScreenValue.CHANGEDISPLAYTYPESTANDARD: 21,
    WorkoutScreenValue.CHANGEDISPLAYTYPEFORCEVELOCITY: 22,
    WorkoutScreenValue.CHANGEDISPLAYTYPEPACEBOAT: 23,
    WorkoutScreenValue.CHANGEDISPLAYTYPEPERSTROKE: 24,
    WorkoutScreenValue.CHANGEDISPLAYTYPESIMPLE: 25,
    WorkoutScreenValue.CHANGEUNITSTYPETIMEMETERS: 30,
    WorkoutScreenValue.CHANGEUNITSTYPEPACE: 31,
    WorkoutScreenValue.CHANGEUNITSTYPEWATTS: 32,
    WorkoutScreenValue.CHANGEUNITSTYPECALORICBURNRATE: 33,
    WorkoutScreenValue.TARGETGAMEBASIC: 34,
    WorkoutScreenValue.TARGETGAMEADVANCED: 35,
    WorkoutScreenValue.DARTGAME: 36,
    WorkoutScreenValue.GOTOUSBWAITREADY: 37,
    WorkoutScreenValue.TACHCABLETESTDISABLE: 38,
    WorkoutScreenValue.TACHSIMDISABLE: 39,
    WorkoutScreenValue.TACHSIMENABLERATE1: 40,
    WorkoutScreenValue.TACHSIMENABLERATE2: 41,
    WorkoutScreenValue.TACHSIMENABLERATE3: 42,
    WorkoutScreenValue.TACHSIMENABLERATE4: 43,
    WorkoutScreenValue.TACHSIMENABLERATE5: 44,
    WorkoutScreenValue.TACHCABLETESTENABLE: 45,
    WorkoutScreenValue.CHANGEUNITSTYPECALORIES: 46,
    WorkoutScreenValue.VIRTUALKEY_A: 47,
    WorkoutScreenValue.VIRTUALKEY_B: 48,
    WorkoutScreenValue.VIRTUALKEY_C: 49,
    WorkoutScreenValue.VIRTUALKEY_D: 50,
    WorkoutScreenValue.VIRTUALKEY_E: 51,
    WorkoutScreenValue.VIRTUALKEY_UNITS: 52,
    WorkoutScreenValue.VIRTUALKEY_DISPLAY: 53,
    WorkoutScreenValue.VIRTUALKEY_MENU: 54,
    WorkoutScreenValue.TACHSIMENABLERATERANDOM: 55,
    WorkoutScreenValue.SCREENREDRAW: 255
  };

  int get value => _racingScreenValues[this];
  //TODO: error if values not found
  static WorkoutScreenValue fromInt(int i) =>
      _racingScreenValues.map((key, value) => MapEntry(value, key))[i];
}

enum OperationalState {
  /// Reset state (0).
  OPERATIONALSTATE_RESET,

  /// Ready state (1).
  OPERATIONALSTATE_READY,

  /// Workout state (2).
  OPERATIONALSTATE_WORKOUT,

  /// Warm-up state (3).
  OPERATIONALSTATE_WARMUP,

  /// Race state (4).
  OPERATIONALSTATE_RACE,

  /// Power-off state (5).
  OPERATIONALSTATE_POWEROFF,

  /// Pause state (6).
  OPERATIONALSTATE_PAUSE,

  /// Invoke boot loader state (7).
  OPERATIONALSTATE_INVOKEBOOTLOADER,

  /// Power-off ship state (8).
  OPERATIONALSTATE_POWEROFF_SHIP,

  /// Idle charge state (9).
  OPERATIONALSTATE_IDLE_CHARGE,

  /// Idle state (10).
  OPERATIONALSTATE_IDLE,

  /// Manufacturing test state (11).
  OPERATIONALSTATE_MFGTEST,

  /// Firmware update state (12).
  OPERATIONALSTATE_FWUPDATE,

  /// Drag factor state (13).
  OPERATIONALSTATE_DRAGFACTOR,

  /// Drag factor calibration state (100).
  OPERATIONALSTATE_DFCALIBRATION // = 100
}

extension OperationalStateExtension on OperationalState {
  static Map _operationalStateValues = {
    OperationalState.OPERATIONALSTATE_RESET: 0,
    OperationalState.OPERATIONALSTATE_READY: 1,
    OperationalState.OPERATIONALSTATE_WORKOUT: 2,
    OperationalState.OPERATIONALSTATE_WARMUP: 3,
    OperationalState.OPERATIONALSTATE_RACE: 4,
    OperationalState.OPERATIONALSTATE_POWEROFF: 5,
    OperationalState.OPERATIONALSTATE_PAUSE: 6,
    OperationalState.OPERATIONALSTATE_INVOKEBOOTLOADER: 7,
    OperationalState.OPERATIONALSTATE_POWEROFF_SHIP: 8,
    OperationalState.OPERATIONALSTATE_IDLE_CHARGE: 9,
    OperationalState.OPERATIONALSTATE_IDLE: 10,
    OperationalState.OPERATIONALSTATE_MFGTEST: 11,
    OperationalState.OPERATIONALSTATE_FWUPDATE: 12,
    OperationalState.OPERATIONALSTATE_DRAGFACTOR: 13,
    OperationalState.OPERATIONALSTATE_DFCALIBRATION: 100,
  };
  int get value => _operationalStateValues[this];
  //TODO: error if values not found
  static OperationalState fromInt(int i) =>
      _operationalStateValues.map((key, value) => MapEntry(value, key))[i];
}
