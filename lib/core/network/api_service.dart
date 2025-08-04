import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/network/dio_client.dart';
import 'package:recetasperuanas/core/network/models/api_response.dart';

typedef FromJson<T> = T Function(Map<String, dynamic>);

class ApiService {
  final _api = dotenv.env['API']!;
  final _logger = Logger('ApiService');

  Future<ApiResponse<List<T>>> getList<T>({
    required String endpoint,
    required FromJson<T> fromJson,
    Map<String, dynamic>? queryParameters,
    String? authorization,
  }) async {
    try {
      final dioClient = DioClient(baseUrl: _api);
      if (authorization != null) {
        dioClient.updateAuthorization(authorization);
      }

      final result = await dioClient.dio.get<List<dynamic>>(
        endpoint,
        queryParameters: queryParameters,
      );
      final data = result.data ?? [];
      dioClient.clearAuthorization();
      return ApiResponse.success(
        data: data.map((e) => fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<T?>> get<T>({
    required String endpoint,
    required FromJson<T> fromJson,
    Map<String, dynamic>? queryParameters,
    String? authorization,
  }) async {
    assert(T is! List, 'Use `getList` for list responses');
    try {
      final dioClient = DioClient(baseUrl: _api);
      if (authorization != null) {
        dioClient.updateAuthorization(authorization);
      }

      final result = await dioClient.dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParameters,
      );
      final data = result.data?['data'] ?? {};
      dioClient.clearAuthorization();
      return ApiResponse.success(data: data == null ? null : fromJson(data));
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<T?>> post<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    String? authorization,
    required FromJson<T> fromJson,
    bool isLogout = false,
  }) async {
    try {
      final dioClient = DioClient(baseUrl: _api);
      if (authorization != null) {
        dioClient.updateAuthorization(authorization);
      }
      final result = await dioClient.dio.post<Map<String, dynamic>>(
        endpoint,
        data: body,
      );

      final data = result.data?['data'];
      dioClient.clearAuthorization();
      return ApiResponse.success(data: data == null ? null : fromJson(data));
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<dynamic>> put({
    required String endpoint,
    Map<String, dynamic>? data,
    String? authorization,
  }) async {
    try {
      final dioClient = DioClient(baseUrl: _api);
      if (authorization != null) {
        dioClient.updateAuthorization(authorization);
      }

      await dioClient.dio.put<dynamic>(endpoint, data: data);
      dioClient.clearAuthorization();
      return const ApiResponse();
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<dynamic>> putList({
    required String endpoint,
    required List<Map<String, dynamic>> data,
    String? authorization,
  }) async {
    try {
      final dioClient = DioClient(baseUrl: _api);
      if (authorization != null) {
        dioClient.updateAuthorization(authorization);
      }

      await dioClient.dio.put<dynamic>(endpoint, data: data);
      dioClient.clearAuthorization();
      return const ApiResponse();
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<dynamic>> delete({
    required String endpoint,
    Map<String, dynamic>? data,
    String? authorization,
  }) async {
    try {
      final dioClient = DioClient(baseUrl: _api);
      if (authorization != null) {
        dioClient.updateAuthorization(authorization);
      }

      await dioClient.dio.delete<dynamic>(endpoint, data: data);
      dioClient.clearAuthorization();
      return const ApiResponse();
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  ApiResponse<T> _handleError<T>(Object error, StackTrace stackTrace) {
    if (error is DioException) {
      return ApiResponse.error(message: _getErrorMessage(error));
    }
    _logger.severe('Error en la petición', error, stackTrace);
    return ApiResponse.error(message: error.toString());
  }

  String _getErrorMessage(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout => 'Tiempo de conexión agotado',
    DioExceptionType.sendTimeout => 'Tiempo de envío agotado',
    DioExceptionType.receiveTimeout => 'Tiempo de respuesta agotado',
    DioExceptionType.badResponse => _decipherError(error),
    DioExceptionType.cancel => 'Solicitud cancelada',
    DioExceptionType.badCertificate => 'Certificado SSL inválido',
    DioExceptionType.connectionError => 'Error de conexión',
    DioExceptionType.unknown => error.message.toString(),
  };

  String _decipherError(DioException error) {
    if (error.response?.statusCode == 404) {
      final data = error.response?.data;
      try {
        if (data is Map<String, dynamic> && data.containsKey('Message')) {
          _logger.info('Mensaje de error: $data');
          return (jsonDecode(data['Message'] as String) as List)
              .map((e) => (e as Map<String, dynamic>)['Descripcion'] as String)
              .join('\n');
        }
      } catch (e, stackTrace) {
        _logger.severe(
          'Error al mapear el mensaje de error: $data',
          e,
          stackTrace,
        );
      }
    }
    return 'Error desconocido en la respuesta';
  }
}
