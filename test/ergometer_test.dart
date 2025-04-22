import 'package:c2bluetooth/models/ergometer.dart';
import 'package:c2bluetooth/src/dataplex.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterReactiveBle extends Mock implements FlutterReactiveBle {}

class FakeQualifiedCharacteristic extends Fake
    implements QualifiedCharacteristic {}

class FakeDataplex extends Fake implements Dataplex {}

void main() {
  group('Bluetooth tests', () {
    setUp(() {
      registerFallbackValue(Stream.value(ConnectionStateUpdate(
        deviceId: 'fallback',
        connectionState: DeviceConnectionState.disconnected,
        failure: null,
      )));
      registerFallbackValue(DiscoveredDevice(
          id: 'deviceId',
          name: 'deviceName',
          serviceData: {},
          manufacturerData: Uint8List.fromList([1, 1, 1, 1]),
          rssi: 90,
          serviceUuids: []));
      registerFallbackValue(FakeQualifiedCharacteristic());
      registerFallbackValue(Stream<List<int>>.fromIterable([
        [1, 1, 1],
        [2, 2, 2]
      ]));
    });

    test('Ensure DeviceConnectionState to ErgometerConnectionState translation',
        () {
      DiscoveredDevice device = DiscoveredDevice(
          id: 'deviceId',
          name: 'deviceName',
          serviceData: {},
          manufacturerData: Uint8List.fromList([1, 1, 1, 1]),
          rssi: 90,
          serviceUuids: []);
      final fakeConnectionUpdates = Stream<ConnectionStateUpdate>.fromIterable([
        ConnectionStateUpdate(
          deviceId: 'deviceId',
          connectionState: DeviceConnectionState.connecting,
          failure: null,
        ),
        ConnectionStateUpdate(
          deviceId: 'deviceId',
          connectionState: DeviceConnectionState.connected,
          failure: null,
        ),
        ConnectionStateUpdate(
            deviceId: 'deviceId',
            connectionState: DeviceConnectionState.disconnecting,
            failure: null),
        ConnectionStateUpdate(
            deviceId: 'deviceId',
            connectionState: DeviceConnectionState.disconnected,
            failure: null)
      ]);
      final fakeSubscriptionChar = Stream<List<int>>.fromIterable([
        [1, 1, 1],
        [2, 2, 2]
      ]);
      final mockBle = MockFlutterReactiveBle();
      final erg = Ergometer(device, bleClient: mockBle);
      when(() =>
              mockBle.subscribeToCharacteristic(any<QualifiedCharacteristic>()))
          .thenAnswer((_) => fakeSubscriptionChar);
      when(() => mockBle.connectedDeviceStream)
          .thenAnswer((_) => fakeConnectionUpdates);
      expect(
          erg.getMonitorConnectionState,
          emitsInOrder([
            ErgometerConnectionState.connecting,
            ErgometerConnectionState.connected,
            ErgometerConnectionState.disconnected,
            ErgometerConnectionState.disconnected
          ]));
      verifyNever(() => mockBle.connectToDevice(
            id: 'deviceId',
            connectionTimeout: any(named: 'connectionTimeout'),
          ));
    });
    test('Retrieve ErgometerConnectionState status during connection', () {
      // dummy  discovered device
      DiscoveredDevice device = DiscoveredDevice(
          id: 'deviceId',
          name: 'deviceName',
          serviceData: {},
          manufacturerData: Uint8List.fromList([1, 1, 1, 1]),
          rssi: 90,
          serviceUuids: []);
      final fakeSubscriptionChar = Stream<List<int>>.fromIterable([
        [1, 1, 1],
        [2, 2, 2]
      ]);
      final fakeConnectionUpdates = Stream<ConnectionStateUpdate>.fromIterable([
        ConnectionStateUpdate(
          deviceId: 'deviceId',
          connectionState: DeviceConnectionState.connecting,
          failure: null,
        ),
        ConnectionStateUpdate(
          deviceId: 'deviceId',
          connectionState: DeviceConnectionState.connected,
          failure: null,
        )
      ]);
      final mockBle = MockFlutterReactiveBle();
      final erg = Ergometer(device, bleClient: mockBle);
      when(() => mockBle.connectedDeviceStream)
          .thenAnswer((_) => fakeConnectionUpdates);
      when(
        () => mockBle.connectToDevice(
          id: any(named: 'id'),
          connectionTimeout: any(named: 'connectionTimeout'),
        ),
      ).thenAnswer((_) => fakeConnectionUpdates);
      when(() =>
              mockBle.subscribeToCharacteristic(any<QualifiedCharacteristic>()))
          .thenAnswer((_) => fakeSubscriptionChar);
      expect(
          erg.connectAndDiscover(),
          emitsInOrder([
            ErgometerConnectionState.connecting,
            ErgometerConnectionState.connected
          ]));
      verify(() => mockBle.connectToDevice(
            id: 'deviceId',
            connectionTimeout: any(named: 'connectionTimeout'),
          )).called(1);
    });
  });
  test('instantiate from a peripheral', () {
    // final bytes = Uint8List.fromList([0, 0, 0, 128]);
    // expect(CsafeIntExtension.fromBytes(bytes), 128);
    // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
  });
  test('can provide WorkoutSummary data', () {
    // final bytes = Uint8List.fromList([0, 0, 0, 128]);
    // expect(CsafeIntExtension.fromBytes(bytes), 128);
    // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
  });
}
