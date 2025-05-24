import 'dart:async';
import 'dart:typed_data';

import 'package:c2bluetooth/src/dataplex.dart';
import 'package:c2bluetooth/src/packets/base.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBle extends Mock implements FlutterReactiveBle {}

class FakeDevice extends Fake implements DiscoveredDevice {
  @override
  String get id => '01:23:45:67:89:AB';
}

class MockParse extends Mock {
  Concept2CharacteristicData? call(Uint8List bytes);
}

class FakePacket extends Fake implements Concept2CharacteristicData {
  @override
  Map<String, dynamic> asMap() => {'foo': 42};
}

void main() {
  setUpAll(() {
    registerFallbackValue(QualifiedCharacteristic(
      serviceId: Uuid.parse('00000000-0000-0000-0000-000000000000'),
      characteristicId: Uuid.parse('ce060030-43e5-11e4-916c-0800200c9a66'),
      deviceId: 'fallback',
    ));
    registerFallbackValue(Uint8List(0));
  });

  group('Dataplex', () {
    // FIXME: Remove Dataplex subscription at declaration when _validateStreams is ready
    late MockBle ble;
    late DiscoveredDevice device;

    setUp(() {
      ble = MockBle();
      device = FakeDevice();

      when(() => ble.subscribeToCharacteristic(any()))
          .thenAnswer((_) => const Stream.empty());
    });

    test('dataplex construction sanity check', () {
      // Dataplex construction follows Ergometer one
      // We are not connected to the machine at this stage
      // No ble action should be triggered
      Dataplex(device, ble);
      verifyNever(() => ble.connectToDevice(id: any(named: 'id')));
      verifyNever(() => ble.subscribeToCharacteristic(
            any(
                that: isA<QualifiedCharacteristic>().having(
              (c) => c.deviceId,
              'device ID',
              equals(device.id),
            )),
          ));
    });

    test('forwards packet maps to outgoing streams', () async {
      // Ensure subscribed characteristic is parsed and channeled
      // into outgoing streams
      final mockParse = MockParse();
      final fakePacket = FakePacket();
      when(() => mockParse(any())).thenReturn(fakePacket);

      final bleStream = StreamController<List<int>>();
      when(() => ble.subscribeToCharacteristic(any()))
          .thenAnswer((_) => bleStream.stream);

      final dataplex = Dataplex(
        device,
        ble,
        parsePacketFn: mockParse, // inject mock parser
      );

      final out = dataplex.createStream({'foo'}.toSet());

      // Add fake bytes to simulate notification
      bleStream.add([0x00]);

      // Wait for output and verify
      final result = await out.first;
      expect(result, equals(fakePacket.asMap()));

      verify(() => mockParse(any())).called(1);

      await bleStream.close();
    });

    test('dispose cancels BLE subscriptions and closes outgoing streams',
        () async {
      final bleStream = StreamController<Uint8List>();
      when(() => ble.subscribeToCharacteristic(any()))
          .thenAnswer((_) => bleStream.stream);

      final dataplex = Dataplex(device, ble);

      final s1 = dataplex.createStream({'a'}.toSet()).listen((_) {});
      final s2 = dataplex.createStream({'b'}.toSet()).listen((_) {});
      verify(() => ble.subscribeToCharacteristic(
            any(
                that: isA<QualifiedCharacteristic>().having(
              (c) => c.deviceId,
              'device ID',
              equals(device.id),
            )),
          )).called(1);
      dataplex.dispose();

      await expectLater(s1.asFuture<void>(), completes);
      await expectLater(s2.asFuture<void>(), completes);

      expect(() => bleStream.add(Uint8List.fromList([0x00])), returnsNormally);
    });
  });
}
