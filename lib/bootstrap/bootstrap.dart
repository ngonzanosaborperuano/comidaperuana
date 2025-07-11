import 'dart:developer';

import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recetasperuanas/app.dart';
import 'package:recetasperuanas/core/error/error_handler.dart';
import 'package:recetasperuanas/core/init/app_initializer.dart';
import 'package:recetasperuanas/core/logger/logger.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/core/services/clarity.dart';
import 'package:recetasperuanas/firebase_options.dart';

Future<void> bootstrap() async {
  initLogger();
  setupGlobalErrorHandlers();

  // Configurar orientación inteligente basada en el dispositivo
  await _configureDeviceOrientation();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initializeFirebaseAppCheck();
  await initializeApp();

  runApp(ClarityWidget(app: const MyApp(), clarityConfig: clarity()));
}

Future<void> _configureDeviceOrientation() async {
  // Inicializar SharedPreferences para poder leer la configuración
  await SharedPreferencesHelper.init();

  // Obtener preferencia del usuario (por defecto deshabilitada)
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

Future<void> _initializeFirebaseAppCheck() async {
  try {
    log('🔧 Inicializando Firebase App Check...');

    await FirebaseAppCheck.instance.activate(
      // Web provider removido temporalmente - agregar cuando tengas la key válida
      // webProvider: ReCaptchaV3Provider('your-actual-recaptcha-key'),
      androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider:
          kDebugMode ? AppleProvider.debug : AppleProvider.appAttestWithDeviceCheckFallback,
    );

    log('✅ Firebase App Check activado correctamente');

    String? token = await FirebaseAppCheck.instance.getToken();
    if (token != null) {
      log('✅ App Check Token obtenido: ${token.substring(0, 20)}...');
    } else {
      log('❌ No se pudo obtener el token de App Check');
    }
  } catch (e, stackTrace) {
    log('❌ Error al inicializar Firebase App Check: $e');
    log('Stack trace: $stackTrace');
  }
}
