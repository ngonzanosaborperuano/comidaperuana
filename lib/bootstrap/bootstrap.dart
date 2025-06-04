import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recetasperuanas/app.dart';
import 'package:recetasperuanas/core/error/error_handler.dart';
import 'package:recetasperuanas/core/init/app_initializer.dart';
import 'package:recetasperuanas/core/logger/logger.dart';
import 'package:recetasperuanas/firebase_options.dart';

Future<void> bootstrap() async {
  initLogger();
  setupGlobalErrorHandlers();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initializeFirebaseAppCheck();
  await initializeApp();

  runApp(const MyApp());
}

Future<void> _initializeFirebaseAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider:
        kDebugMode ? AppleProvider.debug : AppleProvider.appAttestWithDeviceCheckFallback,
  );

  String? token = await FirebaseAppCheck.instance.getToken();
  log('AppCheck Token: $token');
}
