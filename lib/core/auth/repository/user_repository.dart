import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/network/network.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/shared/repository/base_repository.dart';

class UserRepository extends BaseRepository implements IUserRepository {
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

  @override
  Future<(bool, String)> signInOrRegister(AuthUser user, {int? type}) async {
    try {
      final isExists = await _apiService.get(
        endpoint: '$path/correo/${user.email}',
        fromJson: (id) => id,
      );

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

  @override
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

  @override
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

  @override
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
