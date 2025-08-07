import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/application/auth/use_cases/logout_use_case.dart';
import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class SettingController extends BaseController {
  SettingController({required IUserRepository userRepository, required LogoutUseCase logoutUseCase})
    : _userRepository = userRepository,
      _logoutUseCase = logoutUseCase {
    _logger.info('SettingController initialized');
  }

  @override
  String get name => 'SettingController';

  final IUserRepository _userRepository;
  final LogoutUseCase _logoutUseCase;

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
    final result = await _logoutUseCase.execute();
    if (result.isSuccess) {
      await _userRepository.logout();
    } else {
      _logger.severe('Error al cerrar sesión: ${result.failureValue?.message}');
    }
  }

  /// Actualizar configuración de auto-rotación
  Future<void> toggleAutoRotation(bool enabled) async {
    isAutoRotationEnabled.value = enabled;

    // Guardar preferencia
    await SharedPreferencesHelper.instance.setBool(CacheConstants.autoRotation, value: enabled);

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
