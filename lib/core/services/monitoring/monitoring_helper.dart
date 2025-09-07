import 'package:recetasperuanas/core/services/monitoring/monitoring_service.dart';
import 'package:recetasperuanas/core/services/monitoring/monitoring_service_factory.dart';

/// Helper para facilitar el uso del servicio de monitoreo
/// Sigue el principio de responsabilidad única (SOLID)
class MonitoringHelper {
  static final MonitoringService _monitoringService = MonitoringServiceFactory.create();

  /// Registra un evento de navegación
  static void logNavigation(String screenName) {
    _monitoringService.logEvent(
      'navigation',
      parameters: {'screen': screenName, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  /// Registra un evento de receta vista
  static void logRecipeViewed(String recipeId, String recipeName) {
    _monitoringService.logEvent(
      'recipe_viewed',
      parameters: {
        'recipe_id': recipeId,
        'recipe_name': recipeName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Registra un evento de búsqueda
  static void logSearch(String query, int resultsCount) {
    _monitoringService.logEvent(
      'search',
      parameters: {
        'query': query,
        'results_count': resultsCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Registra un error de la aplicación
  static void logAppError(String error, {StackTrace? stackTrace}) {
    _monitoringService.logError('app_error: $error', stackTrace: stackTrace);
  }

  /// Establece información del usuario
  static void setUserInfo(String userId, {Map<String, String>? attributes}) {
    _monitoringService.setUserInfo(userId, attributes: attributes);
  }

  /// Registra un evento personalizado
  static void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    _monitoringService.logEvent(eventName, parameters: parameters);
  }
}
