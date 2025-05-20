import 'dart:async';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:c2bluetooth/constants.dart' as Identifiers;
import 'package:c2bluetooth/src/dataplex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterReactiveBle extends Mock implements FlutterReactiveBle {}

class FakeQualifiedCharacteristic extends Fake
    implements QualifiedCharacteristic {}

class FakeDataplex extends Fake implements Dataplex {}

late MockFlutterReactiveBle mockBle;
late StreamController<List<int>> characteristicController;
late StreamController<ConnectionStateUpdate> deviceConnectionController;
late DiscoveredDevice device = DiscoveredDevice(
    id: 'deviceId',
    name: 'deviceName',
    serviceData: {},
    manufacturerData: Uint8List.fromList([1, 1, 1, 1]),
    rssi: 90,
    serviceUuids: []);
void main() {
  group('Bluetooth tests', () {
    setUpAll(() {
      // Fallback values
      registerFallbackValue(QualifiedCharacteristic(
          characteristicId: Uuid.parse('c5cc5bf5-2bd1-4d1a-939a-5e15fb9b81a1'),
          serviceId: Uuid.parse('c5cc5bf5-2bd1-4d1a-939a-5e15fb9b81a2'),
          deviceId: device.id));
    });
    setUp(() {
      mockBle = MockFlutterReactiveBle();
      // Mock ReactiveBle methods using streamcontrollers
      characteristicController =
          StreamController<List<int>>.broadcast(sync: true);
      deviceConnectionController =
          StreamController<ConnectionStateUpdate>.broadcast(sync: true);
      when(
        () => mockBle.connectToDevice(
          id: any(named: 'id'),
          connectionTimeout: any(named: 'connectionTimeout'),
        ),
      ).thenAnswer((c) {
        debugPrint("connectToDevice(${c.namedArguments})");
        return deviceConnectionController.stream;
      });
      when(() => mockBle.connectedDeviceStream)
          .thenAnswer((d) => deviceConnectionController.stream);
      when(() =>
              mockBle.subscribeToCharacteristic(any<QualifiedCharacteristic>()))
          .thenAnswer((q) {
        debugPrint("subscribeToCharacteristic(${q.positionalArguments})");
        return characteristicController.stream;
      });
    });
    tearDownAll(() {
      deviceConnectionController.close();
      characteristicController.close();
    });

    test('Ensure DeviceConnectionState to ErgometerConnectionState translation',
        () {
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
      final erg = Ergometer(device, bleClient: mockBle);
      fakeConnectionUpdates.forEach(deviceConnectionController.add);
      StreamSubscription<ErgometerConnectionState> _connection =
          erg.connectAndDiscover().listen((_) {});
      expect(
          erg.getMonitorConnectionState,
          emitsInOrder([
            ErgometerConnectionState.connecting,
            ErgometerConnectionState.connected,
            ErgometerConnectionState.disconnected,
            ErgometerConnectionState.disconnected
          ]));
      _connection.cancel();
    });
    test('Retrieve ErgometerConnectionState status during connection', () {
      final fakeSubscriptionChar = Stream<List<int>>.fromIterable([
        // Each StatusData1 is 18 bytes
        [0x31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 0 m
        [0x31, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 1 m
        [0x31, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 2 m
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
      final erg = Ergometer(device, bleClient: mockBle);
      fakeConnectionUpdates.forEach(deviceConnectionController.add);
      fakeSubscriptionChar.forEach(characteristicController.add);
      expect(
          erg.connectAndDiscover(),
          emitsInOrder([
            ErgometerConnectionState.connecting,
            ErgometerConnectionState.connected
          ]));
      // Connection should happen once
      verify(() => mockBle.connectToDevice(
            id: device.id,
            connectionTimeout: any(named: 'connectionTimeout'),
          )).called(1);
      // Subscribed only to this subscription:
      // - Identifiers.C2_ROWING_CONTROL_SERVICE_UUID
      verify(() => mockBle.subscribeToCharacteristic(any(
              that: isA<QualifiedCharacteristic>().having(
                  (e) => e.characteristicId,
                  'characteristicId',
                  Uuid.parse(
                      Identifiers.C2_ROWING_PM_TRANSMIT_CHARACTERISTIC_UUID)))))
          .called(1);
    });
    test('Monitor for distance data', () async {
      final fakeData = Stream<List<int>>.fromIterable([
        // Each StatusData1 is 18 bytes
        [
          0x31,
          0,
          0,
          0,
          30,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0
        ], // 3 m
        [
          0x31,
          0,
          0,
          0,
          40,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0
        ], // 4 m
        [
          0x31,
          0,
          0,
          0,
          50,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0
        ], // 5 m
      ]);
      final erg = Ergometer(device, bleClient: mockBle);
      final StreamSubscription connection =
          erg.connectAndDiscover().listen((_) {});
      Stream.value(ConnectionStateUpdate(
              deviceId: device.id,
              connectionState: DeviceConnectionState.connected,
              failure: null))
          .forEach(deviceConnectionController.add);
      characteristicController.addStream(fakeData);
      final result = expectLater(
          erg.monitorForData({Keys.ELAPSED_DISTANCE_KEY}),
          emitsInOrder([
            Map.from({Keys.ELAPSED_DISTANCE_KEY: 3}),
            Map.from({Keys.ELAPSED_DISTANCE_KEY: 4}),
            Map.from({Keys.ELAPSED_DISTANCE_KEY: 5}),
          ]));
      await result;
      await connection.cancel();
      // Subscribed only to the subscriptions:
      // - (connect) Identifiers.C2_ROWING_CONTROL_SERVICE_UUID
      // - (createStream) Identifiers.C2_ROWING_MULTIPLEXED_INFORMATION_CHARACTERISTIC_UUID
      final subscribedCharacteristics =
          verify(() => mockBle.subscribeToCharacteristic(captureAny()))
              .captured;
      expect(subscribedCharacteristics[0].characteristicId,
          Uuid.parse(Identifiers.C2_ROWING_PM_TRANSMIT_CHARACTERISTIC_UUID));
      expect(
          subscribedCharacteristics[1].characteristicId,
          Uuid.parse(Identifiers
              .C2_ROWING_MULTIPLEXED_INFORMATION_CHARACTERISTIC_UUID));
    });
  });
}
