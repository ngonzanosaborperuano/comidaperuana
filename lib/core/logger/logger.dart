import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void initLogger() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  }

  Logger.root.onRecord.listen((record) {
    log(record.toString());
    if (record.error != null) {
      log('Error: ${record.error}');
      log('Stack trace: ${record.stackTrace}');
    }
  });
}
