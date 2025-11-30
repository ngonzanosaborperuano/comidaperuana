import 'package:flutter/material.dart';
import 'package:goncook/services/monitoring/monitoring_service.dart';

/// Implementación nula del servicio de monitoreo
/// Útil para desarrollo o cuando no se requiere monitoreo
/// Sigue el principio de sustitución de Liskov (SOLID)
class NullMonitoringService implements MonitoringService {
  @override
  Future<void> initialize() async {
    // No hace nada - implementación nula
  }

  @override
  void startApp(Widget app) {
    // Ejecuta la app directamente sin monitoreo
    runApp(app);
  }

  @override
  void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    // No hace nada - implementación nula
  }

  @override
  void logError(String error, {StackTrace? stackTrace}) {
    // No hace nada - implementación nula
  }

  @override
  void setUserInfo(String userId, {Map<String, String>? attributes}) {
    // No hace nada - implementación nula
  }
}
