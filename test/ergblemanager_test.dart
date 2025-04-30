import 'dart:typed_data';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterReactiveBle extends Mock implements FlutterReactiveBle {}

void main() {
  setUp(() {});
  test('translate the stream of discovered devices as ergometers', () {
    /// The whole purpose of the startErgScan method is to translate
    /// FlutterReactiveBle stream of DiscoveredDevice into Ergometer objects.
    ///
    /// - non-PM5 devices are already filtered-out by FlutterReactiveBle
    /// - during subscribing we return a fake status data

    /// declare ErgBleManager with a mocked Reactive Ble
    final mockReactive = MockFlutterReactiveBle();
    final ble = ErgBleManager.withDependency(bleClient: mockReactive);

    /// create a fake stream of Discovered devices matching C2_ROWING_BASE_UUID service
    final fakePM_1 = DiscoveredDevice(
        id: 'xxxx',
        name: 'PM5_1',
        serviceUuids: [Uuid.parse(Identifiers.C2_ROWING_BASE_UUID)],
        serviceData: {},
        manufacturerData: Uint8List.fromList([1, 0, 0]),
        rssi: 10);
    final fakePM_2 = DiscoveredDevice(
        id: 'yyyy',
        name: 'PM5_2',
        serviceUuids: [Uuid.parse(Identifiers.C2_ROWING_BASE_UUID)],
        serviceData: {},
        manufacturerData: Uint8List.fromList([2, 0, 0]),
        rssi: 10);
    final fakeScan = Stream.fromIterable([fakePM_1, fakePM_2]);

    /// Adding mock answer from the [FlutterReactiveBle]
    when(() => mockReactive.scanForDevices(
            withServices: any(
                named: "withServices",
                that: predicate<List<Uuid>>((services) => services
                    .contains(Uuid.parse(Identifiers.C2_ROWING_BASE_UUID))))))
        .thenAnswer((_) => fakeScan);
    when(() => mockReactive.statusStream)
        .thenAnswer((_) => Stream.value(BleStatus.ready));

    /// Ensure DiscoveredDevice events are translated as Ergometer events
    /// we expect only them in matching order
    expect(
        ble.startErgScan(),
        emitsInOrder([
          predicate<Ergometer>((e) => e.name == fakePM_1.name),
          predicate<Ergometer>((e) => e.name == fakePM_2.name),
          emitsDone,
        ]));
  });
}
