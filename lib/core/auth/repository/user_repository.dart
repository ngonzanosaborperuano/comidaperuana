import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/network/network.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/shared/repository/base_repository.dart';

class UserRepository extends BaseRepository {
  UserRepository({
    required ApiService apiService,
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    ISecureStorageService? secureStorage,
  }) : _apiService = apiService,
       _auth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: <String>['email', 'profile']),
       secureStorageService = secureStorage ?? SecurityStorageService();

  final ApiService _apiService;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final ISecureStorageService secureStorageService;

  @override
  String get name => 'UserRepository';
  static const String path = 'v1/auth';
  static const String usuario = 'v1/users';
  final _logger = Logger('UserRepository');

  Future<(bool, String)> login({required AuthUser user, required int type}) async {
    try {
      if (type == LoginWith.withGoogle) {
        return loginWithGoogle();
      } else if (type == LoginWith.withUserPassword) {
        return loginWithEmailPass(user);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return (false, 'Tipo de inicio de sesión no soportado');
  }

  Future<(bool, String)> loginWithEmailPass(AuthUser user) async {
    try {
      final response = await _auth.signInWithCredential(
        EmailAuthProvider.credential(email: user.email, password: user.contrasena!),
      );
      user = AuthUser(
        email: user.email,
        contrasena: response.user!.uid,
        foto: response.user!.photoURL,
        nombreCompleto: response.user!.displayName,
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

  Future<(bool, String)> signInOrRegister(AuthUser user, {int? type}) async {
    try {
      final isExists = await _apiService.get(
        endpoint: '$path/correo/${user.email}',
        fromJson: (id) => id,
      );

      // final userModel = AuthUser(
      //   nombreCompleto: user.nombreCompleto,
      //   foto: user.foto,
      //   email: user.email,
      //   contrasena: user.contrasena,
      // );
      if (!isExists.success) {
        return (false, 'Error al iniciar sesión o registrar: ${isExists.message}');
      }

      if (isExists.data!['id'] == 0) {
        await register(user, type: type);
      } else {
        await loginWithEmail(user);
      }
      return (true, 'Login or registration successful');
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión o registrar: $e', e, stackTrace);

      return (false, 'Error al iniciar sesión o registrar: $e');
    }
  }

  Future<String?> recoverCredential(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e, stackTrace) {
      debugPrint('StackTrace: $stackTrace');
      return 'Ocurrió un error inesperado.';
    }
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
        id: jsonData!.id,
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
      // Obtener token de App Check antes de operaciones de autenticación
      // await _ensureAppCheckToken(); // Eliminado

      // // final clientIdIOS = Platform.isIOS ? dotenv.env['CLIENT_ID']! : null;
      // // final clientIdAndroid = Platform.isIOS ? dotenv.env['SERVER_CLIENT_ID']! : null;
      // final GoogleSignIn googleSignIn = GoogleSignIn(
      //   scopes: <String>['email'],
      //   // clientId: clientIdIOS,
      //   // serverClientId: clientIdAndroid,
      // );

      // if (await googleSignIn.isSignedIn()) {
      //   await googleSignIn.signOut();
      // }

      // final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();

      // if (signInAccount == null) {
      //   return (false, 'Google sign-in aborted by user');
      // }

      // final GoogleSignInAuthentication googleAuth = await signInAccount.authentication;

      // final OAuthCredential oauthCredentials = GoogleAuthProvider.credential(
      //   idToken: googleAuth.idToken,
      //   accessToken: googleAuth.accessToken,
      // );
      // if (oauthCredentials.accessToken == null || oauthCredentials.idToken == null) {
      //   return (false, 'Google sign-in failed: No access token or ID token received.');
      // }
      // final result = await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      // Trigger del flujo de autenticación
      // Asegúrate de que no hay sesiones previas
      // Primero, verifica si hay una sesión activa
      // Primero, verifica si hay una sesión activa

      await _googleSignIn.signOut(); // Forzar cierre de sesión anterior
      await _auth.signOut(); // Limpiar sesión de Firebase
      // Limpiar cualquier caché de autenticación

      // Esperar un momento para asegurar que todo se limpió
      await Future.delayed(const Duration(milliseconds: 500));

      // Intentar el nuevo sign in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        log('Google Sign In fue cancelado por el usuario');
        return (false, 'Google sign-in aborted by user');
      }

      // Obtener detalles de autenticación con manejo de errores
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication.catchError((
        error,
      ) {
        log('Error en autenticación de Google: $error');
        throw error;
      });

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        log('No se pudieron obtener los tokens necesarios');
        return (false, 'Google sign-in aborted by user');
      }

      // Crear credencial
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase
      final result = await _auth.signInWithCredential(credential);
      final data = result.user!;
      AuthUser user = AuthUser(
        email: data.email!,
        contrasena: data.uid,
        foto: data.photoURL,
        nombreCompleto: data.displayName,
      );
      return await signInOrRegister(user, type: LoginWith.withGoogle);
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión con Google: $e', e, stackTrace);
      return (false, e.code);
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión con Google: $e', e, stackTrace);
      return (false, e.toString());
    }
  }

  Future<bool> register(AuthUser user, {int? type}) async {
    try {
      if (type == LoginWith.withUserPassword) {
        final response = await _auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.contrasena!,
        );
        final data = response.user!;
        user = AuthUser(
          email: user.email,
          contrasena: data.uid,
          nombreCompleto: user.nombreCompleto,
          foto:
              user.foto ??
              'https://cdn-icons-png.freepik.com/256/12894/12894535.png?semt=ais_hybrid',
        );
      }

      final result = await _apiService.post(
        endpoint: usuario,
        body: user.toJson(),
        fromJson: (id) => id,
      );

      if (result.success == false) return false;

      await loginWithEmail(user);

      return true;
    } catch (e, stackTrace) {
      _logger.severe('Error al registrar: $e', e, stackTrace);
      return false;
    }
  }

  /// Asegura que hay un token válido de App Check antes de operaciones de autenticación
  // Future<void> _ensureAppCheckToken() async {
  //   try {
  //     // Intentar obtener un token de App Check
  //     await FirebaseAppCheck.instance.getToken(true); // forceRefresh = true
  //     log('✅ Token de App Check obtenido para operación de autenticación');
  //   } catch (e) {
  //     log('⚠️ No se pudo obtener token de App Check: $e');
  //     log('ℹ️ Continuando con la operación...');
  //     // No lanzar el error para permitir que la operación continúe
  //   }
  // }

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
      await _googleSignIn.signOut();
      await _auth.signOut();
      await secureStorageService.deleteCredentials();
    } catch (e, stackTrace) {
      _logger.severe('Error: $e', e, stackTrace);
      addError(e, stackTrace);
    }
  }
}
