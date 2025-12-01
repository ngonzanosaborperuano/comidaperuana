import 'dart:developer';

import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goncook/app.dart';
import 'package:goncook/common/errors/error_handler.dart';
import 'package:goncook/core/config/firebase_config.dart';
import 'package:goncook/core/config/flavors_config.dart';
import 'package:goncook/core/init/app_initializer.dart';
import 'package:goncook/core/logger/logger.dart';
import 'package:goncook/services/audio/audio_service.dart';
import 'package:goncook/services/clarity.dart';
import 'package:goncook/services/monitoring/monitoring_service_factory.dart';
import 'package:goncook/services/storage/preferences/preferences.dart';

Future<void> bootstrap() async {
  initLogger();
  setupGlobalErrorHandlers();
  _initSystemUI();
  await _loadEnvironmentVariables();
  await _configureDeviceOrientation();
  await _initializeFirebase();
  await initializeApp();
  await _initializeMonitoring();
  await _initializeAudio();

  // Crear la app
  final app = ClarityWidget(app: const MyApp(), clarityConfig: clarity());

  // Siempre usar runApp para evitar problemas de zona
  runApp(app);
}

Future<void> _initializeMonitoring() async {
  try {
    final monitoringService = MonitoringServiceFactory.create();
    await monitoringService.initialize();
  } catch (e) {
    log('❌ Error al inicializar servicio de monitoreo: $e');
    // En desarrollo, podemos continuar sin monitoreo
    if (kDebugMode) {
      log('ℹ️ Continuando sin monitoreo en modo debug');
    } else {
      rethrow; // En producción, es crítico
    }
  }
}

Future<void> _initializeAudio() async {
  try {
    await AudioService.initialize();
  } catch (e) {
    log('❌ Error al inicializar servicio de audio: $e');
    // Continuar sin audio - no es crítico para el funcionamiento de la app
    log('ℹ️ Continuando sin funcionalidad de audio');
  }
}

Future<void> _initializeFirebase() async {
  try {
    // Usar FirebaseConfig que ya maneja la lógica de flavors
    await FirebaseConfig.initializeFirebase();
  } catch (e) {
    log('❌ Error al inicializar Firebase: $e');
    // En desarrollo, podemos continuar sin Firebase
    if (kDebugMode) {
      log('ℹ️ Continuando sin Firebase en modo debug');
    } else {
      rethrow; // En producción, es crítico
    }
  }
}

Future<void> _loadEnvironmentVariables() async {
  try {
    await dotenv.load(fileName: ".env"); // lo común

    final enviroment = ".env.${FlavorsConfig.instance.flavor.name}";

    await dotenv.load(fileName: enviroment, mergeWith: {...dotenv.env});
  } catch (e) {
    log('⚠️ No se pudo cargar el archivo .env: $e');
    log('ℹ️ Usando valores por defecto para PayU');
  }
}

Future<void> _configureDeviceOrientation() async {
  await SharedPreferencesHelper.init();

  final isAutoRotationEnabled = SharedPreferencesHelper.instance.getBool(
    CacheConstants.autoRotation,
  );

  if (isAutoRotationEnabled) {
    log('📱 Auto-rotación habilitada por el usuario - Permitiendo todas las orientaciones');
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    log('📱 Auto-rotación deshabilitada - Solo modo vertical');
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

void _initSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}
