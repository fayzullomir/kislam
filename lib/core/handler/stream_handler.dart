import 'dart:async';

import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/error/app_exception.dart';

extension StreamExtensions<T> on Stream<T> {
  StreamHandler<T> initStream() => StreamHandler(this);
}

class StreamHandler<T> {
  final Stream<T> stream;
  StreamSubscription<T>? _subscription;

  Function? _onStart;
  Function(T data)? _onData;
  Function(AppException error)? _onError;
  Function? _onDone;

  StreamHandler(this.stream);

  StreamHandler<T> onStart(Function callback) {
    _onStart = callback;
    return this;
  }

  StreamHandler<T> onData(Function(T data) callback) {
    _onData = callback;
    return this;
  }

  StreamHandler<T> onError(Function(AppException error) callback) {
    _onError = callback;
    return this;
  }

  StreamHandler<T> onDone(Function callback) {
    _onDone = callback;
    return this;
  }

  StreamSubscription<T> execute() {
    _onStart?.call();
    _subscription = stream.listen(
      (data) => _onData?.call(data),
      onError: (e, s) {
        AppLog.e("StreamHandler error", error: e, stackTrace: s);
        _onError?.call(e.objectToAppException(s));
      },
      onDone: () => _onDone?.call(),
    );
    return _subscription!;
  }

  void cancel() {
    _subscription?.cancel();
  }
}
