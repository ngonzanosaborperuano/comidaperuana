import 'package:recetasperuanas/src/infrastructure/shared/services/monitoring/dynatrace_monitoring_service.dart';
import 'package:recetasperuanas/src/infrastructure/shared/services/monitoring/monitoring_service.dart';
import 'package:recetasperuanas/src/infrastructure/shared/services/monitoring/null_monitoring_service.dart';
import 'package:recetasperuanas/src/shared/core/config/flavors_config.dart';

/// Factory para crear instancias del servicio de monitoreo
/// Sigue el principio de responsabilidad única (SOLID)
class MonitoringServiceFactory {
  /// Crea una instancia del servicio de monitoreo apropiado
  /// basado en el entorno y configuración de flavors
  static MonitoringService create() {
    // En desarrollo, usar servicio nulo para evitar overhead
    if (FlavorsConfig.isDev) {
      return NullMonitoringService();
    }

    // En staging y producción, usar Dynatrace
    if (FlavorsConfig.isStaging || FlavorsConfig.isProd) {
      return DynatraceMonitoringService();
    }

    // Fallback: usar servicio nulo si no se puede determinar el flavor
    return NullMonitoringService();
  }

  /// Crea una instancia específica de Dynatrace
  /// Útil para testing o cuando se requiere explícitamente
  static MonitoringService createDynatrace() {
    return DynatraceMonitoringService();
  }

  /// Crea una instancia nula
  /// Útil para testing o cuando se requiere deshabilitar monitoreo
  static MonitoringService createNull() {
    return NullMonitoringService();
  }
}
