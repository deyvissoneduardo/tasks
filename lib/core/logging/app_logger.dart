import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void debug(String message) {
    if (kDebugMode) {
      debugPrint('[debug] $message');
    }
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[error] $message');
      if (error != null) {
        debugPrint(error.toString());
      }
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }
}
