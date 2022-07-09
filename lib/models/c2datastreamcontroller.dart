import 'dart:async';

/// A wrapper around StreamController to aid in delivering data from bluetooth to the user
///
/// This is intended to add functionality enabling:
/// - filtering of data sent to the `add` function so this stream can only send datapoints that it was created to send
/// - caching of data in the event that users want a full set of data any time any value is updated
/// and possibly more.
class C2DataStreamController implements StreamController<Map<String, dynamic>> {
  StreamController<Map<String, dynamic>> _controller;

  /// A list of the identifying strings for datapoints that this controller should pass on as stream updates.
  Set<String> datapoint_identifiers;

  ///called when the controller loses its last subscriber
  ///https://dart.dev/articles/libraries/creating-streams#using-a-streamcontroller
  @override
  FutureOr<void> Function()? get onCancel => _controller.onCancel;

  set onCancel(FutureOr<void> Function()? newValue) {
    _controller.onCancel = newValue;
  }

  ///called when the stream gets its first subscriber
  ///https://dart.dev/articles/libraries/creating-streams#using-a-streamcontroller
  @override
  void Function()? get onListen => _controller.onListen;

  set onListen(Function()? newValue) {
    _controller.onListen = newValue;
  }

  @override
  void Function()? get onPause => _controller.onPause;

  set onPause(Function()? newValue) {
    _controller.onPause = newValue;
  }

  @override
  void Function()? get onResume => _controller.onResume;

  set onResume(Function()? newValue) {
    _controller.onResume = newValue;
  }

  C2DataStreamController(this.datapoint_identifiers,
      {void onListen()?,
      void onPause()?,
      void onResume()?,
      FutureOr<void> onCancel()?})
      : _controller = new StreamController<Map<String, dynamic>>(
            onListen: onListen,
            onPause: onPause,
            onResume: onResume,
            onCancel: onCancel);

  @override
  void add(Map<String, dynamic> event) {
    //source: https://stackoverflow.com/a/21131220
    // filter keys so that only ones that affect this stream get added to the controller
    final filteredMap = new Map<String, dynamic>.fromIterable(
        event.keys.where((k) => datapoint_identifiers.contains(k)),
        value: (k) => event[k]);
    if (filteredMap.length > 0) {
      _controller.add(filteredMap);
    }
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  @override
  Future addStream(Stream<Map<String, dynamic>> source, {bool? cancelOnError}) {
    return _controller.addStream(source, cancelOnError: cancelOnError);
  }

  @override
  Future close() {
    return _controller.close();
  }

  @override
  Future get done => _controller.done;

  @override
  bool get hasListener => _controller.hasListener;

  @override
  bool get isClosed => _controller.isClosed;

  @override
  bool get isPaused => _controller.isPaused;

  @override
  StreamSink<Map<String, dynamic>> get sink => _controller.sink;

  @override
  Stream<Map<String, dynamic>> get stream => _controller.stream;
}
