import 'dart:typed_data';

import 'package:c2bluetooth/helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converting a time from bytes', () {
    final bytes = Uint8List.fromList([156, 42, 1, 14]);
    expect(timeFromBytes(bytes), DateTime(2021, 12, 9, 14, 1));
    // expect(CsafeIntExtension.fromBytes(bytes, Endian.little), 2147483648);
  });
}
