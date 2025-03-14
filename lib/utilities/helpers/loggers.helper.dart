import 'package:logger/logger.dart';

class LNDLogger {
  LNDLogger._();

  // Logger instances
  static final Logger _logger = Logger(
    printer: PrettyPrinter(lineLength: 80, colors: false),
  );

  // No stack trace
  static final Logger _loggerNoStack = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      lineLength: 80,
      colors: false,
      errorMethodCount: 0,
    ),
  );

  /// Logs a trace message.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  /// [stackTrace] (optional) - A stack trace associated with the log.
  static void t(
    String message, {
    dynamic error,
    required StackTrace stackTrace,
  }) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a debug message.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  /// [stackTrace] (optional) - A stack trace associated with the log.
  static void d(
    String message, {
    dynamic error,
    required StackTrace stackTrace,
  }) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an informational message.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  /// [stackTrace] (optional) - A stack trace associated with the log.
  static void i(
    String message, {
    dynamic error,
    required StackTrace stackTrace,
  }) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  /// [stackTrace] (optional) - A stack trace associated with the log.
  static void w(
    String message, {
    dynamic error,
    required StackTrace stackTrace,
  }) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  /// [stackTrace] (optional) - A stack trace associated with the log.
  static void e(
    String message, {
    dynamic error,
    required StackTrace stackTrace,
  }) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a fatal message.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  /// [stackTrace] (optional) - A stack trace associated with the log.
  static void f(
    String message, {
    dynamic error,
    required StackTrace stackTrace,
  }) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a trace message without including the stack trace.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  static void tNoStack(String message, {dynamic error}) {
    _loggerNoStack.t(message, error: error);
  }

  /// Logs a debug message without including the stack trace.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  static void dNoStack(String message, {dynamic error}) {
    _loggerNoStack.d(message, error: error);
  }

  /// Logs an informational message without including the stack trace.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  static void iNoStack(String message, {dynamic error}) {
    _loggerNoStack.i(message, error: error);
  }

  /// Logs a warning message without including the stack trace.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  static void wNoStack(String message, {dynamic error}) {
    _loggerNoStack.w(message, error: error);
  }

  /// Logs an error message without including the stack trace.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  static void eNoStack(String message, {dynamic error}) {
    _loggerNoStack.e(message, error: error);
  }

  /// Logs a fatal message without including the stack trace.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  static void fNoStack(String message, {dynamic error}) {
    _loggerNoStack.f(message, error: error);
  }
}
