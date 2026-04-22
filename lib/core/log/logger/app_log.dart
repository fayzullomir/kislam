import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLog {
  static late final Logger _logger;

  static void init() {
    final levelColors = {
      Level.trace: AnsiColor.fg(245),
      Level.debug: AnsiColor.fg(135),
      Level.info: AnsiColor.fg(72),
      Level.warning: AnsiColor.fg(214),
      Level.error: AnsiColor.fg(197),
      Level.fatal: AnsiColor.fg(200),
    };
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 3,
        colors: true,
        noBoxingByDefault: true,
        printEmojis: false,
        printTime: false,
        levelColors: levelColors,
      ),
      level: kDebugMode ? Level.debug : Level.off,
    );
  }

  static void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    try{
    _logger.d(message, time: time, error: error, stackTrace: stackTrace);
    } catch (e) {
      _logger.d("Logger m: $message, t: $time, e: $error, s: $stackTrace");
    }
  }

  static void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    try {
      _logger.i(message, time: time, error: error, stackTrace: stackTrace);
    } catch (e) {
      _logger.i("Logger m: $message, t: $time, e: $error, s: $stackTrace");
    }
  }

  static void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    try {
      _logger.w(message, time: time, error: error, stackTrace: stackTrace);
    } catch (e) {
      _logger.w("Logger m: $message, t: $time, e: $error, s: $stackTrace");
    }
  }

  static void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    try {
      _logger.e(message, time: time, error: error, stackTrace: stackTrace);
    } catch (e) {
      _logger.e("Logger m: $message, t: $time, e: $error, s: $stackTrace");
    }
  }
}
