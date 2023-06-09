import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// extension LoggerExtension on Logger {
//   Logger get logger => Logger();
// }

var logger = Logger(
  filter: ReleaseFilter(),
  printer: PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

extension DynamicLog<T> on T? {
  logE() {
    logger.e(this);
  }

  logD() {
    logger.d(this);
  }

  print() {
    kPrint(this);
  }
}

kPrint(Object? object, {Level level = Level.debug, bool usePrint = false}) {
  if (!kReleaseMode) {
    if (usePrint) {
      print("$object");
    } else {
      logger.log(level, "$object");
    }
  }
}

class ReleaseFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return !kReleaseMode;
  }
}
