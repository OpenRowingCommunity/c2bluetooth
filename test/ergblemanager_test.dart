import 'dart:typed_data';

import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:c2bluetooth/models/ergblemanager.dart';

class MockFlutterReactiveBle extends Mock implements FlutterReactiveBle {}

void main() {
  setUp(() {
    registerFallbackValue(Stream.value(DiscoveredDevice(
        id: 'deviceId',
        name: 'deviceName',
        serviceData: {
          Uuid.parse(Identifiers.C2_ROWING_BASE_UUID):
              Uint8List.fromList([1, 1, 1])
        },
        manufacturerData: Uint8List.fromList([1, 1, 1, 1]),
        rssi: 90,
        serviceUuids: [])));
    registerFallbackValue(Stream<List<int>>.fromIterable([
      [1, 1, 1],
      [2, 2, 2]
    ]));
  });
  test('startErgScan test', () {
    final _mockDiscoveredDevice = Stream.value(DiscoveredDevice(
        id: 'deviceId',
        name: 'deviceName',
        serviceData: {},
        manufacturerData: Uint8List.fromList([1, 1, 1, 1]),
        rssi: 90,
        serviceUuids: []));
    final mockReactive = MockFlutterReactiveBle();
    final ble = ErgBleManager(bleClient: mockReactive);
    when(() => mockReactive.scanForDevices(
            withServices: any<List<Uuid>>(named: "withServices")))
        .thenAnswer((_) => _mockDiscoveredDevice);
    ble.startErgScan().listen((data) {
      print(data.toString());
    });
  });
  test('can obtain stream of ergometers present', () {
    // final bytes = Uint8List.fromList([0, 0, 0, 128]);
    // expect(CsafeIntExtension.fromBytes(bytes), 128);
    // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
  });

  test('does not recognize non-concept2 devices', () {
    // final bytes = Uint8List.fromList([0, 0, 0, 128]);
    // expect(CsafeIntExtension.fromBytes(bytes), 128);
    // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
  });
}
