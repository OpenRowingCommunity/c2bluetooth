import 'package:c2bluetooth/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, int> dummyDataKeyToCharacteristicMap = {
    "something.something": 0xAB,
    "something.something.average": 0xAB
  };

  Map<int, Set<String>> dummySwappedMap = {
    0xAB: {"something.something", "something.something.average"}
  };

  group("getCharacteristicToDataKeysMap - ", () {
    test("test returns expected value", () {
      expect(getCharacteristicToDataKeysMap(dummyDataKeyToCharacteristicMap),
          dummySwappedMap);
    });
  });
}
