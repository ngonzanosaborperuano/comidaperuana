import 'package:flutter/material.dart';

/// Interfaz abstracta para servicios de monitoreo
/// Sigue el principio de inversión de dependencias (SOLID)
abstract class MonitoringService {
  /// Inicializa el servicio de monitoreo
  Future<void> initialize();

  /// Inicia el monitoreo de la aplicación
  void startApp(Widget app);

  /// Registra un evento personalizado
  void logEvent(String eventName, {Map<String, dynamic>? parameters});

  /// Registra un error
  void logError(String error, {StackTrace? stackTrace});

  /// Registra información de usuario
  void setUserInfo(String userId, {Map<String, String>? attributes});
}
