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

Future<void> _initializeFirebaseAppCheck() async {
  try {
    log('🔧 Inicializando Firebase App Check...');

    await FirebaseAppCheck.instance.activate(
      // En desarrollo, usar solo debug providers para evitar errores de App Attest
      androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
    );

    log('✅ Firebase App Check activado correctamente');

    // Obtener un token inicial para evitar errores en operaciones de autenticación
    try {
      await Future.delayed(const Duration(seconds: 1)); // Pequeño delay para estabilizar
      String? token = await FirebaseAppCheck.instance.getToken(true); // forceRefresh = true
      if (token != null) {
        log('✅ Token de App Check obtenido: ${token.substring(0, 20)}...');
      } else {
        log('⚠️ No se pudo obtener el token de App Check inicial');
      }
    } catch (tokenError) {
      log('⚠️ Error al obtener token inicial de App Check: $tokenError');
      log('ℹ️ La app continuará funcionando - App Check se manejará automáticamente');
    }
  } catch (e, stackTrace) {
    log('❌ Error al inicializar Firebase App Check: $e');
    log('Stack trace: $stackTrace');
    // No lanzar el error para que la app pueda continuar funcionando
  }
}
