/// Archivo de definición de API para Pigeon
/// 
/// Este archivo define la interfaz de comunicación tipo-safe entre Flutter
/// y código nativo (Android/iOS). Pigeon genera automáticamente el código
/// necesario para ambas plataformas.
/// 
/// Para generar el código, ejecutar:
/// ```bash
/// dart run pigeon --input pigeon/api.dart
/// ```

import 'package:pigeon/pigeon.dart';

/// Configuración para generar código Flutter
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/services/pigeon/generated_api.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/ngonzano/goncook/PigeonApi.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.ngonzano.goncook',
    ),
    swiftOut: 'ios/Runner/PigeonApi.swift',
    swiftOptions: SwiftOptions(),
  ),
)

/// Ejemplo: API para obtener información del dispositivo
/// 
/// Este es un ejemplo básico. Puedes agregar más APIs según tus necesidades.
@HostApi()
abstract class DeviceInfoApi {
  /// Obtiene el modelo del dispositivo
  String getDeviceModel();

  /// Obtiene la versión del sistema operativo
  String getOsVersion();

  /// Obtiene el ID único del dispositivo
  String getDeviceId();
}

/// Ejemplo: API para operaciones de almacenamiento seguro
/// 
/// Permite almacenar y recuperar datos de forma segura desde código nativo
@HostApi()
abstract class SecureStorageApi {
  /// Guarda un valor de forma segura
  /// 
  /// [key] - Clave para identificar el valor
  /// [value] - Valor a guardar
  /// Retorna true si se guardó correctamente
  bool saveSecureValue(String key, String value);

  /// Recupera un valor guardado de forma segura
  /// 
  /// [key] - Clave del valor a recuperar
  /// Retorna el valor o null si no existe
  String? getSecureValue(String key);

  /// Elimina un valor guardado
  /// 
  /// [key] - Clave del valor a eliminar
  /// Retorna true si se eliminó correctamente
  bool deleteSecureValue(String key);
}

/// Ejemplo: API bidireccional para notificaciones
/// 
/// Permite que el código nativo envíe eventos a Flutter
@FlutterApi()
abstract class NotificationApi {
  /// Notifica a Flutter cuando llega una notificación push
  /// 
  /// [title] - Título de la notificación
  /// [body] - Cuerpo de la notificación
  /// [data] - Datos adicionales en formato JSON
  void onNotificationReceived(String title, String body, Map<String, Object?> data);
}

/// Ejemplo: Clase de datos para pasar información compleja
/// 
/// Pigeon puede serializar clases de datos automáticamente
class DeviceInfo {
  DeviceInfo({
    required this.model,
    required this.osVersion,
    required this.deviceId,
    this.brand,
  });

  final String model;
  final String osVersion;
  final String deviceId;
  final String? brand;
}

/// API que retorna objetos complejos
@HostApi()
abstract class DeviceInfoComplexApi {
  /// Obtiene información completa del dispositivo
  DeviceInfo getDeviceInfo();
}
