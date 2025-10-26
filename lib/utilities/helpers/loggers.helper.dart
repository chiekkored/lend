import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    String formattedError = _parseError(error);

    _logger.e(message, error: formattedError, stackTrace: stackTrace);
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
    String formattedError = _parseError(error);

    _loggerNoStack.e(message, error: formattedError);
  }

  /// Logs a fatal message without including the stack trace.
  /// [message] - The message to log.
  /// [error] (optional) - An error object to log along with the message.
  static void fNoStack(String message, {dynamic error}) {
    _loggerNoStack.f(message, error: error);
  }

  /// Try to extract human-friendly error details from dynamic objects,
  /// including Firebase/Firestore exceptions.
  static String _parseError(dynamic error) {
    if (error == null) return 'Unknown error';

    try {
      // Handle Firebase & Firestore exceptions
      if (error is FirebaseException) {
        // FirebaseException has code & message fields
        final code = error.code;
        final msg = error.message ?? 'No message';
        return 'FirebaseException(code: $code, message: $msg)';
      }
    } catch (_) {}

    // If class has a `code` / `message` but not FirebaseException,
    // we reflectively try to get them:
    try {
      final dynamic maybeCode =
          error.code; // ignore: invalid_use_of_protected_member
      final dynamic maybeMsg = error.message;
      if (maybeCode != null || maybeMsg != null) {
        return 'Error(code: ${maybeCode ?? "n/a"}, message: ${maybeMsg ?? error.toString()})';
      }
    } catch (_) {}

    // Generic fallback for Exception / Error
    if (error is Exception || error is Error) {
      debugPrint('HEREEEEEEE: ${error}');
      return error.toString();
    }

    // String error
    if (error is String) {
      return error;
    }

    // Last-ditch fallback: stringify
    try {
      return error.toString();
    } catch (_) {
      return 'Error: ${error.runtimeType}';
    }
  }
}
