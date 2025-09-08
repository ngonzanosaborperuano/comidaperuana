import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:recetasperuanas/src/shared/storage/preferences/preferences.dart';

abstract class BaseRepository {
  @protected
  @visibleForOverriding
  String get name;

  @protected
  Logger get logger => Logger(name);

  void addError(Object error, [StackTrace? stackTrace]) {
    logger.severe(error.toString(), error, stackTrace);
  }

  Future<void> saveLastRequestDate() async {
    final currentDate = DateTime.now();
    await SharedPreferencesHelper.instance.setString(
      CacheConstants.validTime,
      currentDate.toIso8601String(),
    );
  }

  bool hasOneDayPassed() {
    final lastRequestDateString = SharedPreferencesHelper.instance.getString(
      CacheConstants.validTime,
    );
    if (lastRequestDateString == null) return true;

    final lastRequestDate = DateTime.parse(lastRequestDateString);
    final currentDate = DateTime.now();

    return currentDate.isAfter(lastRequestDate.add(const Duration(days: 1)));
  }
}
