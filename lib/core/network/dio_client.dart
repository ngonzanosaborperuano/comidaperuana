import 'package:dio/dio.dart';

import 'package:logging/logging.dart';

final _logger = Logger('DioClient');

class DioClient {
  factory DioClient({required String baseUrl}) =>
      _instances.putIfAbsent(baseUrl, () => DioClient._internal(baseUrl));

  DioClient._internal(String baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.info('Request: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.info('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.severe('Error: ${e.response?.statusCode}', e);
          return handler.next(e);
        },
      ),
    );
  }

  static final Map<String, DioClient> _instances = {};

  late final Dio _dio;

  Dio get dio => _dio;
}
