// import 'package:dio/dio.dart';
// import 'package:logging/logging.dart';
// import 'package:recetasperuanas/core/network/app_check_interceptor.dart';

// final _logger = Logger('DioClient');

// class DioClient {
//   factory DioClient({required String baseUrl, String? authorization}) {
//     print('authorization: $authorization');
//     return _instances.putIfAbsent(
//       baseUrl,
//       () => DioClient._internal(baseUrl, authorization: authorization),
//     );
//   }

//   DioClient._internal(String baseUrl, {String? authorization}) {
//     var headers = <String, String>{};
//     if (authorization == null) {
//       headers = <String, String>{'Content-Type': 'application/json'};
//     } else {
//       headers = <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': authorization,
//       };
//     }
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: baseUrl,
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//         headers: headers,
//       ),
//     )..interceptors.add(AppCheckInterceptor());

//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           _logger.info('Request: ${options.method} ${options.uri}');
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           _logger.info('Response: ${response.statusCode} ${response.data}');
//           return handler.next(response);
//         },
//         onError: (DioException e, handler) {
//           _logger.severe('Error: ${e.response?.statusCode}', e);
//           return handler.next(e);
//         },
//       ),
//     );
//   }

//   static final Map<String, DioClient> _instances = {};

//   late final Dio _dio;

//   Dio get dio => _dio;
// }

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/network/app_check_interceptor.dart';

final _logger = Logger('DioClient');

class DioClient {
  static final Map<String, DioClient> _instances = {};

  final Dio _dio;

  Dio get dio => _dio;

  // Token que se puede actualizar dinámicamente
  String? _authorization;

  // Singleton Factory
  factory DioClient({required String baseUrl, String? initialToken}) {
    return _instances.putIfAbsent(
      baseUrl,
      () => DioClient._internal(baseUrl, initialToken),
    );
  }

  DioClient._internal(String baseUrl, String? token)
    : _authorization = token,
      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': token,
          },
        ),
      ) {
    _dio.interceptors.add(AppCheckInterceptor());
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.info('[REQ] ${options.method} ${options.uri}');
          if (_authorization != null) {
            options.headers['Authorization'] = _authorization;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.info('[RES] ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.severe('[ERR] ${e.response?.statusCode}', e);
          return handler.next(e);
        },
      ),
    );
  }

  /// Actualiza dinámicamente el token
  void updateAuthorization(String token) {
    _authorization = token;
    _dio.options.headers['Authorization'] = token;
  }

  /// Limpia el token (logout)
  void clearAuthorization() {
    _authorization = null;
    _dio.options.headers.remove('Authorization');
  }
}
