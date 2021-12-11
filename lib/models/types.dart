// Some of these use classes instead of enums as doxumented in
// https://medium.com/@ra9r/overcoming-the-limitations-of-dart-enum-8866df8a1c47
// because they need to be mapped to specific values

class MachineType {
  final int _value;

  int get value => _value;
  const MachineType._(this._value);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_STATIC_D = MachineType._(0);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_STATIC_C = MachineType._(1);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_STATIC_A = MachineType._(2);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_STATIC_B = MachineType._(3);
  static const MachineType ERGMACHINE_TYPE_STATIC_E = MachineType._(5);
  static const MachineType ERGMACHINE_TYPE_STATIC_SIMULATOR = MachineType._(7);
  static const MachineType ERGMACHINE_TYPE_STATIC_DYNAMIC = MachineType._(8);
  static const MachineType ERGMACHINE_TYPE_SLIDES_A = MachineType._(16);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_SLIDES_B = MachineType._(17);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_SLIDES_C = MachineType._(18);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_SLIDES_D = MachineType._(19);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_SLIDES_E = MachineType._(20);
  static const MachineType ERGMACHINE_TYPE_SLIDES_DYNAMIC = MachineType._(32);
  static const MachineType ERGMACHINE_TYPE_STATIC_DYNO = MachineType._(64);
  static const MachineType ERGMACHINE_TYPE_STATIC_SKI = MachineType._(128);
  static const MachineType ERGMACHINE_TYPE_STATIC_SKI_SIMULATOR =
      MachineType._(143);
  static const MachineType ERGMACHINE_TYPE_BIKE = MachineType._(192);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_BIKE_ARMS = MachineType._(193);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_BIKE_NOARMS = MachineType._(194);
  static const MachineType ERGMACHINE_TYPE_BIKE_SIMULATOR = MachineType._(207);
  static const MachineType ERGMACHINE_TYPE_MULTIERG_ROW = MachineType._(224);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_MULTIERG_SKI = MachineType._(225);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_MULTIERG_BIKE = MachineType._(226);
  //value assumed
  static const MachineType ERGMACHINE_TYPE_NUM = MachineType._(227);
}
