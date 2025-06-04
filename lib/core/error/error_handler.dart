import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void setupGlobalErrorHandlers() {
  FlutterError.onError = (details) {
    Logger('Flutter').severe('Flutter error', details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    Logger('Flutter').severe('Platform error', error, stack);
    return true;
  };
}
