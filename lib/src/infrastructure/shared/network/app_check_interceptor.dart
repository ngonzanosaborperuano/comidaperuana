import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:logging/logging.dart';

class AppCheckInterceptor extends Interceptor {
  final _logger = Logger('AppCheckInterceptor');

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      String? appCheckToken = await FirebaseAppCheck.instance.getToken();

      if (appCheckToken != null) {
        options.headers['X-Firebase-AppCheck'] = appCheckToken;
        _logger.info(
          '✅ App Check token enviado: ${appCheckToken.substring(0, 20)}...',
        );
      } else {
        _logger.severe('❌ No se pudo obtener el token de App Check');
      }
    } catch (e, stackTrace) {
      _logger.severe('❌ Error al obtener App Check token: $e', e, stackTrace);
    }

    return handler.next(options);
  }
}
