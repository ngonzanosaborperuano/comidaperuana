import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/network/network.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/shared/repository/base_repository.dart';

class UserRepository extends BaseRepository {
  UserRepository({required ApiService apiService}) : _apiService = apiService;
  final ApiService _apiService;
  @override
  String get name => 'UserRepository';
  static const String path = 'users';
  final _logger = Logger('UserRepository');
  ISecureStorageService secureStorageService = SecurityStorageService();

  Future<bool?> login({required AuthUser user, required int type}) async {
    try {
      if (type == LoginWith.withGoogle) {
        return loginWithGoogle();
      } else if (type == LoginWith.withUserPassword) {
        return loginWithEmail(user);
      }
      return false;
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return null;
  }

  Future<bool?> loginWithEmail(AuthUser user) async {
    try {
      final result = await _apiService.post<AuthUser>(
        endpoint: '$path/login',
        body: user.toJson(),
        fromJson: AuthUser.fromJson,
      );

      if (result.success == false) return false;
      final jsonData = result.data;
      final userModel = AuthUser(
        id: int.parse(jsonData!.id.toString()),
        nombreCompleto: jsonData.nombreCompleto,
        foto: jsonData.foto,
        email: user.email,
        contrasena: user.contrasena,
        sessionToken: jsonData.sessionToken,
      );

      await secureStorageService.saveCredentials(userModel);

      return true;
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return null;
  }

  Future<bool> loginWithGoogle() async {
    try {
      final clientIdIOS = Platform.isIOS ? dotenv.env['CLIENT_ID']! : null;
      final clientIdAndroid = Platform.isIOS ? dotenv.env['SERVER_CLIENT_ID']! : null;
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>['email'],
        clientId: clientIdIOS,
        serverClientId: clientIdAndroid,
      );

      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();

      if (signInAccount == null) {
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await signInAccount.authentication;

      final OAuthCredential oauthCredentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final result = await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      _logger.info(result.user);
      final user = result.user!;

      final isExists = await _apiService.get(endpoint: '$path/${user.email}', fromJson: (id) => id);

      final userModel = AuthUser(
        nombreCompleto: user.displayName,
        foto: user.photoURL,
        email: user.email!,
        contrasena: user.uid,
      );

      if (isExists.data!['id'] == 0) {
        await register(userModel);
      } else {
        await loginWithEmail(userModel);
      }

      return true;
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión con Google: $e', e, stackTrace);
      rethrow;
    }
  }

  Future<bool?> register(AuthUser user) async {
    try {
      final result = await _apiService.post(
        endpoint: path,
        body: user.toJson(),
        fromJson: (id) => id,
      );

      if (result.success == false) return false;

      await loginWithEmail(user);

      return true;
    } catch (e, stackTrace) {
      _logger.severe('Error al registrar: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return null;
  }

  Future<AuthUser> getUser() async {
    try {
      final userData = await secureStorageService.loadCredentials();

      return userData ?? AuthUser.empty();
    } catch (e, stackTrace) {
      _logger.severe('Error: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return AuthUser.empty();
  }

  Future<void> logout() async {
    try {
      await secureStorageService.deleteCredentials();
    } catch (e, stackTrace) {
      _logger.severe('Error: $e', e, stackTrace);
      addError(e, stackTrace);
    }
  }
}
