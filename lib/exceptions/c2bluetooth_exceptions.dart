/// Public exceptions for c2bluetooth
abstract class C2BluetoothException implements Exception {
  final String message;
  final Object? cause;

  C2BluetoothException(this.message, [this.cause]);

  @override
  String toString() {
    return 'C2BluetoothException: $message'
        '${cause != null ? ' (caused by $cause)' : ''}';
  }
}

/// Error while connecting to and Ergometer
class C2ConnectionException extends C2BluetoothException {
  C2ConnectionException(String message, [Object? cause])
      : super(message, cause);
}

/// Error while subscribing to Bluetooth characteristics (Dataplex, etc.)
class DataSubscriptionException extends C2BluetoothException {
  DataSubscriptionException(String message, [Object? cause])
      : super(message, cause);
}

/// Error while configuring a workout
class WorkoutConfigurationException extends C2BluetoothException {
  WorkoutConfigurationException(String message, [Object? cause])
      : super(message, cause);
}

/// CSAFE communication error
class CsafeCommunicationException extends C2BluetoothException {
  CsafeCommunicationException(String message, [Object? cause])
      : super(message, cause);
}
