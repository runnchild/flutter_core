import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// extension LoggerExtension on Logger {
//   Logger get logger => Logger();
// }

var logger = Logger();

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

kPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}
