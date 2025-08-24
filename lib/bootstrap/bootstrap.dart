import 'dart:developer';

import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recetasperuanas/app.dart';
import 'package:recetasperuanas/core/config/firebase_config.dart';
import 'package:recetasperuanas/core/error/error_handler.dart';
import 'package:recetasperuanas/core/init/app_initializer.dart';
import 'package:recetasperuanas/core/logger/logger.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/core/services/clarity.dart';

Future<void> bootstrap() async {
  initLogger();
  setupGlobalErrorHandlers();
  _initSystemUI();
  await _loadEnvironmentVariables();
  await _configureDeviceOrientation();
  await _initializeFirebase();
  await initializeApp();

  runApp(ClarityWidget(app: const MyApp(), clarityConfig: clarity()));
}

Future<void> _initializeFirebase() async {
  try {
    log('🔧 Inicializando Firebase...');

    // Usar FirebaseConfig que ya maneja la lógica de flavors
    await FirebaseConfig.initializeFirebase();
    log('✅ Firebase inicializado correctamente usando FirebaseConfig');
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
    log('🔧 Cargando variables de entorno...');
    await dotenv.load(fileName: '.env');
    log('✅ Variables de entorno cargadas correctamente');

    // Log de configuración PayU (sin mostrar credenciales completas)
    final merchantId = dotenv.env['PAYU_MERCHANT_ID'] ?? 'No configurado';
    final currency = dotenv.env['PAYU_CURRENCY'] ?? 'No configurado';
    final testMode = dotenv.env['PAYU_TEST_MODE'] ?? 'No configurado';

    log(
      '📋 Configuración PayU: MerchantID=$merchantId, Currency=$currency, TestMode=$testMode',
    );
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
    log(
      '📱 Auto-rotación habilitada por el usuario - Permitiendo todas las orientaciones',
    );
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
