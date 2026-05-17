import 'package:goncook/core/services/monitoring/monitoring_service.dart';
import 'package:goncook/core/services/monitoring/null_monitoring_service.dart';

/// Factory para crear instancias del servicio de monitoreo
/// Sigue el principio de responsabilidad única (SOLID)
class MonitoringServiceFactory {
  /// Crea el servicio de monitoreo (actualmente no-op en todos los flavors).
  static MonitoringService create() {
    return NullMonitoringService();
  }

  /// Útil para testing o cuando se requiere deshabilitar monitoreo
  static MonitoringService createNull() {
    return NullMonitoringService();
  }
}
