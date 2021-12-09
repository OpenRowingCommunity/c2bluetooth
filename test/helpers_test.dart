import 'dart:typed_data';

import 'package:c2bluetooth/helpers.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:c2bluetooth/c2bluetooth.dart';

void main() {
  test('can convert a byte list to an integer', () {
    final bytes = Uint8List.fromList([0, 0, 0, 128]);
    expect(bytesToInt(bytes), 128);
    expect(bytesToInt(bytes, Endian.little), 2147483648);
  });
}
