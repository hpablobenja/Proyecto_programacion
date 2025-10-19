import 'dart:developer' as devtools;

class Logger {
  static void log(String message) {
    devtools.log(message);
  }

  static void error(String message, [dynamic error]) {
    devtools.log('ERROR: $message ${error ?? ''}');
  }
}
