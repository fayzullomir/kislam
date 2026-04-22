import 'dart:async';

import 'package:koreaislam/core/channel/selection_result.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';

class BaseChannel<T> {
  final StreamController<T> _controller;

  BaseChannel({
    bool sync = false,
    bool isBroadcast = false,
  }) : _controller = isBroadcast
            ? StreamController<T>.broadcast(sync: sync)
            : StreamController<T>(sync: sync);

  Stream<T> get stream => _controller.stream;

  void add(T data) {
    _controller.add(data);
  }

  Future<void> addAndClose(T data) async {
    _controller.add(data);
    await _controller.close();
  }

  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  Future<void> close() {
    return _controller.close();
  }

  bool get isClosed => _controller.isClosed;

  bool get hasListener => _controller.hasListener;

  StreamSink<T> get sink => _controller.sink;

  StreamSubscription<T> listen(
    void Function(T data)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _controller.stream.listen(
      onData,
      onError: onError ??
          (error, stackTrace) {
            AppLog.e("Stream error: $error",
                error: error, stackTrace: stackTrace);
          },
      onDone: onDone ??
          () {
            AppLog.i("Stream has been closed.");
          },
      cancelOnError: cancelOnError ?? true,
    );
  }
}

class BaseSelectionChannel<T> extends BaseChannel<SelectionResult<T>> {
  BaseSelectionChannel({super.isBroadcast = true});

  void addForKey(String requestKey, T data) {
    add(SelectionResult(requestKey: requestKey, data: data));
  }

  StreamSubscription<T> listenFor(
    String requestKey,
    void Function(T data) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return stream
        .where((result) => result.requestKey == requestKey)
        .map((result) => result.data)
        .listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
  }
}
