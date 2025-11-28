import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goncook/src/infrastructure/shared/services/monitoring/dynatrace_config.dart';
import 'package:goncook/src/infrastructure/shared/services/monitoring/monitoring_service.dart';

class DynatraceMonitoringService implements MonitoringService {
  bool _isInitialized = false;
  late final DynatraceEnvironmentConfig _config;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _config = DynatraceConfig.currentConfig;

      if (_config.environment == 'development') {
        _isInitialized = true;
        return;
      }

      _isInitialized = true;
    } catch (e) {
      log('Error al configurar Dynatrace: $e');
    }
  }

  @override
  void startApp(Widget app) {}

  @override
  void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (!_isInitialized) return;

    if (_config.environment == 'development') {
      return;
    }

    //try {
    //  Dynatrace().reportEvent(eventName);
    //} catch (e) {
    //  debugPrint('Error al registrar evento en Dynatrace: $e');
    //}
  }

  @override
  void logError(String error, {StackTrace? stackTrace}) {
    if (!_isInitialized) return;

    if (_config.environment == 'development') {
      debugPrint('❌ [DEV] Error: $error');
      if (stackTrace != null) {
        debugPrint('❌ [DEV] StackTrace: $stackTrace');
      }
      return;
    }

    //try {
    //  Dynatrace().reportError(error, 0);
    //  debugPrint('❌ [${_config.environment.toUpperCase()}] Error enviado: $error');
    //} catch (e) {
    //  debugPrint('Error al registrar error en Dynatrace: $e');
    //}
  }

  @override
  void setUserInfo(String userId, {Map<String, String>? attributes}) {
    if (!_isInitialized) return;

    // En desarrollo, solo logear localmente
    if (_config.environment == 'development') {
      debugPrint('👤 [DEV] Usuario: $userId, Atributos: $attributes');
      return;
    }

    //try {
    //  Dynatrace().identifyUser(userId);
    //  debugPrint('👤 [${_config.environment.toUpperCase()}] Usuario identificado: $userId');
    //} catch (e) {
    //  debugPrint('Error al establecer información de usuario en Dynatrace: $e');
    //}
  }
}
