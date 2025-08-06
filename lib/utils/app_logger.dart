import 'dart:developer' as developer;

/// Logger utility to replace print statements and provide better logging
class AppLogger {
  static const String _name = 'TeamShare';
  static bool _isDebugMode = false;

  /// Initialize logger with debug mode setting
  static void init({bool debugMode = false}) {
    _isDebugMode = debugMode;
  }

  /// Log debug information (only in debug mode)
  static void debug(String message, {String? tag}) {
    if (_isDebugMode) {
      developer.log(
        message,
        name: tag ?? _name,
        level: 500, // Debug level
      );
    }
  }

  /// Log general information
  static void info(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? _name,
      level: 800, // Info level
    );
  }

  /// Log warnings
  static void warning(String message, {String? tag, Object? error}) {
    developer.log(
      message,
      name: tag ?? _name,
      level: 900, // Warning level
      error: error,
    );
  }

  /// Log errors
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? _name,
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log network requests
  static void network(String message, {String? tag}) {
    if (_isDebugMode) {
      developer.log(message, name: tag ?? '${_name}_Network', level: 500);
    }
  }

  /// Log authentication events
  static void auth(String message, {String? tag}) {
    if (_isDebugMode) {
      developer.log(message, name: tag ?? '${_name}_Auth', level: 500);
    }
  }

  /// Log performance metrics
  static void performance(String message, {String? tag}) {
    if (_isDebugMode) {
      developer.log(message, name: tag ?? '${_name}_Performance', level: 600);
    }
  }
}
