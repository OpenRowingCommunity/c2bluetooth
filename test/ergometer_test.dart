import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks(
    [MockSpec<DiscoveredDevice>(), MockSpec<FlutterReactiveBle>()])
import 'ergometer_test.mocks.dart';

// import '../lib/models/ergometer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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

  test('equality', () {
    var pheri = MockDiscoveredDevice();
    var mgr = MockFlutterReactiveBle();
    when(pheri.name).thenReturn("PM6 12345678");
    when(pheri.id).thenReturn("12:34:56:78:91:23");
    var pheri2 = MockDiscoveredDevice();
    var mgr2 = MockFlutterReactiveBle();

    when(pheri2.name).thenReturn("PM6 12345678");
    when(pheri2.id).thenReturn("12:34:56:78:91:23");
    var erg = Ergometer(pheri, flutterReactiveBle: mgr);
    var erg2 = Ergometer(pheri2, flutterReactiveBle: mgr2);
    expect(erg.id, erg2.id);
    expect(erg.hashCode, erg2.hashCode);
    expect(erg, erg2);
  });
}
