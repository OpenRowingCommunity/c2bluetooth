import 'dart:typed_data';
import './base.dart';

/// Represents a series of force curve data for a stroke
class ForceCurveData extends Concept2CharacteristicData {
  List<int> data;

  static Set<String> get datapointIdentifiers =>
      ForceCurveData.zero().asMap().keys.toSet();

  ForceCurveData.zero() : this.fromBytes(Uint8List(20));

  /// Construct a set of ForceCurveData from the bytes returned from the erg
  ForceCurveData.fromBytes(Uint8List data) : this.data = data.toList();
}
