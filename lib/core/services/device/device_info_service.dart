/// Servicio para obtener información del dispositivo usando Pigeon
/// 
/// Este servicio encapsula la comunicación con código nativo a través
/// de la API generada por Pigeon, siguiendo Clean Architecture.
import 'package:fpdart/fpdart.dart';
import 'package:goncook/core/errors/failures.dart';
import 'package:goncook/core/services/pigeon/generated_api.dart';
import 'package:logging/logging.dart';

/// Servicio para obtener información del dispositivo
/// 
/// Utiliza Pigeon para comunicación tipo-safe con código nativo.
/// Sigue Clean Architecture usando Either<Failure, T> para manejo de errores.
class DeviceInfoService {
  final _logger = Logger('DeviceInfoService');
  final DeviceInfoApi _api;

  DeviceInfoService({DeviceInfoApi? api}) : _api = api ?? DeviceInfoApi();

  /// Obtiene el modelo del dispositivo
  /// 
  /// Retorna Either<Failure, String> con el modelo o un error
  Future<Either<Failure, String>> getDeviceModel() async {
    try {
      _logger.fine('Getting device model');
      final model = await _api.getDeviceModel();
      _logger.info('Device model retrieved: $model');
      return Right(model);
    } catch (e, stackTrace) {
      _logger.severe('Error getting device model', e, stackTrace);
      return Left(PlatformFailure('Failed to get device model: $e'));
    }
  }

  /// Obtiene la versión del sistema operativo
  /// 
  /// Retorna Either<Failure, String> con la versión o un error
  Future<Either<Failure, String>> getOsVersion() async {
    try {
      _logger.fine('Getting OS version');
      final version = await _api.getOsVersion();
      _logger.info('OS version retrieved: $version');
      return Right(version);
    } catch (e, stackTrace) {
      _logger.severe('Error getting OS version', e, stackTrace);
      return Left(PlatformFailure('Failed to get OS version: $e'));
    }
  }

  /// Obtiene el ID único del dispositivo
  /// 
  /// Retorna Either<Failure, String> con el ID o un error
  Future<Either<Failure, String>> getDeviceId() async {
    try {
      _logger.fine('Getting device ID');
      final deviceId = await _api.getDeviceId();
      _logger.info('Device ID retrieved');
      return Right(deviceId);
    } catch (e, stackTrace) {
      _logger.severe('Error getting device ID', e, stackTrace);
      return Left(PlatformFailure('Failed to get device ID: $e'));
    }
  }

  /// Obtiene información completa del dispositivo
  /// 
  /// Retorna Either<Failure, DeviceInfo> con toda la información o un error
  Future<Either<Failure, DeviceInfo>> getDeviceInfo() async {
    try {
      _logger.fine('Getting complete device info');
      
      final modelResult = await getDeviceModel();
      final osVersionResult = await getOsVersion();
      final deviceIdResult = await getDeviceId();

      return modelResult.flatMap((model) =>
        osVersionResult.flatMap((osVersion) =>
          deviceIdResult.map((deviceId) => DeviceInfo(
            model: model,
            osVersion: osVersion,
            deviceId: deviceId,
          ))
        )
      );
    } catch (e, stackTrace) {
      _logger.severe('Error getting device info', e, stackTrace);
      return Left(UnknownFailure('Failed to get device info: $e'));
    }
  }
}
