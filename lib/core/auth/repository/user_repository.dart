import 'dart:convert';

import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/network/network.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/shared/models/user_model.dart';

import 'package:recetasperuanas/shared/repository/base_repository.dart';
import 'package:logging/logging.dart';

class UserRepository extends BaseRepository {
  UserRepository({required ApiService apiService}) : _apiService = apiService;
  final ApiService _apiService;
  @override
  String get name => 'UserRepository';
  static const String path = 'api';
  static const int baseUrl = BaseUrl.reqReslUrl;
  final _logger = Logger('UserRepository');
  ISecureStorageService secureStorageService = SecurityStorageService();

  Future<bool?> login(AuthUser user) async {
    try {
      final result = await _apiService.post(
        endpoint: '$path/login',
        data: user.toJson(),
      );

      if (result.success == false) return false;

      final jsonData = jsonDecode(result.data.toString());

      final userModel = AuthUser(
        email: user.email,
        password: user.password,
        token: jsonData['token'].toString(),
      );

      await secureStorageService.saveCredentials(userModel);

      return true;
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return null;
  }

  Future<bool?> register(AuthUser user) async {
    try {
      final result = await _apiService.post(
        endpoint: '$path/register',
        data: user.toJson(),
      );

      if (result.success == false) return false;
      final jsonData = jsonDecode(result.data.toString());

      final userModel = AuthUser(
        id: (jsonData['id'] as num).toInt(),
        email: user.email,
        password: user.password,
        token: jsonData['token'].toString(),
      );

      secureStorageService.saveCredentials(userModel);
      return true;
    } catch (e, stackTrace) {
      _logger.severe('Error al registrar: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return null;
  }

  Future<UserModel> getUser() async {
    try {
      final userData = await secureStorageService.loadCredentials();
      final result = await _apiService.get<UserModel>(
        endpoint: '$path/users/${userData?.id}',
        fromJson: UserModel.fromJson,
      );

      if (!result.success) return UserModel.empty;
      _logger.info(result.data);
      return result.data ?? UserModel.empty;
    } catch (e, stackTrace) {
      _logger.severe('Error: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return UserModel.empty;
  }
}
