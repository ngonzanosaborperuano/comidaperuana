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

  Future<(bool, String)> login({required AuthUser user, required int type}) async {
    try {
      if (type == LoginWith.withGoogle) {
        return loginWithGoogle();
      } else if (type == LoginWith.withUserPassword) {
        return loginWithEmailPass(user);
        // return loginWithEmail(user);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return (false, 'Tipo de inicio de sesión no soportado');
  }

  Future<(bool, String)> loginWithEmailPass(AuthUser user) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(
        EmailAuthProvider.credential(email: user.email, password: user.contrasena!),
      );

      return await signInOrRegister(user);
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión con email y contraseña: $e', e, stackTrace);
      return (false, e.code);
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión con email y contraseña: $e', e, stackTrace);
      return (false, 'An error occurred during email/password login: $e');
    }
  }

  Future<(bool, String)> signInOrRegister(AuthUser user) async {
    try {
      final isExists = await _apiService.get(endpoint: '$path/${user.email}', fromJson: (id) => id);

      final userModel = AuthUser(
        nombreCompleto: user.nombreCompleto,
        foto: user.foto,
        email: user.email,
        contrasena: user.contrasena,
      );

      if (isExists.data!['id'] == 0) {
        await register(userModel);
      } else {
        await loginWithEmail(userModel);
      }
      return (true, 'Login or registration successful');
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión o registrar: $e', e, stackTrace);

      return (false, 'Error al iniciar sesión o registrar: $e');
    }
  }

  Future<String?> recoverCredential(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Ocurrió un error inesperado.';
    }
    return null;
  }

  Future<bool> loginWithEmail(AuthUser user) async {
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
    return false;
  }

  Future<(bool, String)> loginWithGoogle() async {
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
        return (false, 'Google sign-in aborted by user');
      }

      final GoogleSignInAuthentication googleAuth = await signInAccount.authentication;

      final OAuthCredential oauthCredentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      if (oauthCredentials.accessToken == null || oauthCredentials.idToken == null) {
        return (false, 'Google sign-in failed: No access token or ID token received.');
      }
      final result = await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      final data = result.user!;
      AuthUser user = AuthUser(
        email: data.email!,
        contrasena: result.user!.uid,
        foto: data.photoURL,
        nombreCompleto: data.displayName,
      );
      return await signInOrRegister(user);
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión con Google: $e', e, stackTrace);
      return (false, e.code);
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión con Google: $e', e, stackTrace);
      return (false, e.toString());
    }
  }

  Future<bool> register(AuthUser user) async {
    try {
      final result = await _apiService.post(
        endpoint: path,
        body: user.toJson(),
        fromJson: (id) => id,
      );

      if (result.success == false) return false;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.contrasena!,
      );

      await loginWithEmail(user);

      return true;
    } catch (e, stackTrace) {
      _logger.severe('Error al registrar: $e', e, stackTrace);
      addError(e, stackTrace);
      return false;
    }
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
      final data = (await secureStorageService.loadCredentials())!;
      final result = await _apiService.post(
        endpoint: '$path/logout',
        authorization: data.sessionToken,
        body: {"id": data.id},
        fromJson: (p0) => p0,
      );
      if (!result.success) return;

      await secureStorageService.deleteCredentials();
      await FirebaseAuth.instance.signOut();
    } catch (e, stackTrace) {
      _logger.severe('Error: $e', e, stackTrace);
      addError(e, stackTrace);
    }
  }
}
