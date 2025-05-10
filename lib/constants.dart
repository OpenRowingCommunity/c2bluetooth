const String C2_ROWING_BASE_UUID =
    "CE060000-43E5-11E4-916C-0800200C9A66"; // cr2rowing base PM UUID

// CE061800-43E5-11E4-916C-0800200C9A66 //GAP service UUID
// CE062A00-43E5-11E4-916C-0800200C9A66 //GAP device name characteristic
//CONTROL SERVICE

const String C2_DEVICE_INFO_SERVICE_UUID =
    "CE060010-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_CONTROL_SERVICE_UUID =
    "CE060020-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_PM_RECEIVE_CHARACTERISTIC_UUID =
    "CE060021-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_PM_TRANSMIT_CHARACTERISTIC_UUID =
    "CE060022-43E5-11E4-916C-0800200C9A66";
const String C2_ROWING_PRIMARY_SERVICE_UUID =
    "CE060030-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_GENERAL_STATUS_CHARACTERISTIC_UUID =
    "CE060031-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_ADDITIONAL_STATUS1_UUID =
    "CE060032-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_ADDITIONAL_STATUS2_UUID =
    "CE060033-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_SAMPLE_RATE_UUID =
    "CE060034-43E5-11E4-916C-0800200C9A66"; // sample rate read/write

const String C2_ROWING_STROKE_DATA_UUID =
    "CE060035-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_ADDITIONAL_STROKE_UUID =
    "CE060036-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_SPLIT_INTERVAL_DATA_CHARACTERISTIC_UUID =
    "CE060037-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_SPLIT_INTERVAL_DATA_CHARACTERISTIC2_UUID =
    "CE060038-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC_UUID =
    "CE060039-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_END_OF_WORKOUT_SUMMARY_CHARACTERISTIC2_UUID =
    "CE06003A-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_FORCE_CURVE_UUID =
    "CE060040-43E5-11E4-916C-0800200C9A66";

const String C2_ROWING_MULTIPLEXED_INFORMATION_CHARACTERISTIC_UUID =
    "CE060080-43E5-11E4-916C-0800200C9A66";

// CE060010-43E5-11E4-916C-0800200C9A66 //C2 device info service uuid
// CE060012-43E5-11E4-916C-0800200C9A66 //C2 serial number string characteristic
// CE060013-43E5-11E4-916C-0800200C9A66 //C2 hardware revision string characteristic
// CE060014-43E5-11E4-916C-0800200C9A66 //C2 firmware revision string characteristic
// CE060015-43E5-11E4-916C-0800200C9A66 //C2 manufacturer string characteristic

const Map<String, int> dataKeyToCharacteristicMap = {
  "something.something": 0xAB,
  "something.something.average": 0xAB
};

Map<int, Set<String>> getCharacteristicToDataKeysMap(
    Map<String, int> keyToCharacteristicMap) {
  Map<int, Set<String>> out = Map();
  for (var entry in dataKeyToCharacteristicMap.entries) {
    var key = entry.key;
    var value = entry.value;

    var currentSet = out[value];

    if (currentSet != null) {
      currentSet.add(key);
    } else {
      out[value] = {key};
    }
  }
  return out;
}

Map<int, Set<String>> characteristicToDataKeysMap =
    getCharacteristicToDataKeysMap(dataKeyToCharacteristicMap);
