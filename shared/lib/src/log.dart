import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  const Log._();
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      excludeBox: {
        Level.trace: true,
        Level.info: true,
        Level.debug: true,
      }
    ),
    level: kDebugMode ? Level.debug : Level.info,
  );

  static d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.d(message, time: time, error: error, stackTrace: stackTrace);
  }

  static e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message, time: time, error: error, stackTrace: stackTrace);
  }

  static i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.i(message, time: time, error: error, stackTrace: stackTrace);
  }

  static w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.w(message, time: time, error: error, stackTrace: stackTrace);
  }
}
