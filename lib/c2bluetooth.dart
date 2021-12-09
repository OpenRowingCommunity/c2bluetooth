library c2bluetooth;

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
class WorkoutSummary {
  final int elapsedTime;

  WorkoutSummary.fromBytes(Uint8List data)
      : elapsedTime = data.sublist(4, 7).buffer.asByteData().getUint64(0);
}
