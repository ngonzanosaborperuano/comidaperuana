import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class SettingController extends BaseController {
  SettingController({required UserRepository userRepository}) : _userRepository = userRepository {
    _logger.info('SettingController initialized');
  }

  @override
  String get name => 'SettingController';

  final UserRepository _userRepository;

  final _logger = Logger('LoginController');

  AuthUser userModel = AuthUser.empty();

  final isSpanish = ValueNotifier<bool>(false);
  final isDark = ValueNotifier<bool>(false);
  final isAutoRotationEnabled = ValueNotifier<bool>(false);

  Future<void> getUser() async {
    userModel = await _userRepository.getUser();
    loadAutoRotationSetting(); // Cargar configuración de rotación
    notifyListeners();
  }

  Future<void> logout() async {
    await _userRepository.logout();
  }

  /// Actualizar configuración de auto-rotación
  Future<void> toggleAutoRotation(bool enabled) async {
    isAutoRotationEnabled.value = enabled;
    
    // Guardar preferencia
    await SharedPreferencesHelper.instance.setBool(
      CacheConstants.autoRotation, 
      value: enabled,
    );
    
    // Aplicar configuración inmediatamente
    await _updateDeviceOrientation(enabled);
    
    _logger.info('Auto-rotación ${enabled ? 'habilitada' : 'deshabilitada'}');
  }

  /// Actualizar orientación del dispositivo basada en la configuración
  Future<void> _updateDeviceOrientation(bool autoRotationEnabled) async {
    if (autoRotationEnabled) {
      // Permitir todas las orientaciones
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Solo modo vertical
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  /// Cargar configuración de auto-rotación al inicializar
  void loadAutoRotationSetting() {
    final enabled = SharedPreferencesHelper.instance.getBool(CacheConstants.autoRotation);
    isAutoRotationEnabled.value = enabled;
  }
}
