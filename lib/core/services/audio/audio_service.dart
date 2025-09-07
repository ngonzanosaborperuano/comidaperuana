import 'dart:developer';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

/// Servicio de audio para manejar grabación de voz
/// Sigue el principio de responsabilidad única (SOLID)
class AudioService {
  static FlutterSoundRecorder? _recorder;
  static bool _isInitialized = false;

  /// Inicializa el servicio de audio
  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Solicitar permisos
      final permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        return false;
      }

      // Inicializar el grabador
      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();

      _isInitialized = true;
      return true;
    } catch (e) {
      log('❌ Error al inicializar servicio de audio: $e');
      return false;
    }
  }

  /// Obtiene el grabador de audio
  static FlutterSoundRecorder? get recorder {
    if (!_isInitialized) {
      log('⚠️ Servicio de audio no inicializado');
      return null;
    }
    return _recorder;
  }

  /// Libera los recursos del servicio de audio
  static Future<void> dispose() async {
    if (_recorder != null) {
      await _recorder!.closeRecorder();
      _recorder = null;
    }
    _isInitialized = false;
    log('🔧 Servicio de audio liberado');
  }

  /// Verifica si el servicio está inicializado
  static bool get isInitialized => _isInitialized;
}
