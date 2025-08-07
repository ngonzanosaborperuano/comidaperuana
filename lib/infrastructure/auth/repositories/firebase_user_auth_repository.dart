import 'dart:developer' show log;

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, GoogleAuthProvider, EmailAuthProvider, FirebaseAuthException;
import 'package:google_sign_in/google_sign_in.dart'
    show GoogleSignIn, GoogleSignInAccount, GoogleSignInAuthentication;
import 'package:logging/logging.dart' show Logger;
import 'package:recetasperuanas/core/auth/models/auth_user.dart' show AuthUser;
import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

class FirebaseUserAuthRepository implements IUserAuthRepository {
  FirebaseUserAuthRepository(FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn)
    : _auth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: <String>['email', 'profile']);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final Logger _logger = Logger('FirebaseUserAuthRepository');

  @override
  Future<Result<AuthUser, DomainException>> authenticateGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      await Future.delayed(const Duration(milliseconds: 100));

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        log('Google Sign In fue cancelado por el usuario');
        return const Failure(ValidationException('Google sign-in aborted by user'));
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
        return const Failure(ValidationException('Google sign-in aborted by user'));
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

      return Success(user);
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión con email y contraseña: $e', e, stackTrace);
      return Failure(ValidationException(e.code));
    }
  }

  @override
  Future<Result<AuthUser, DomainException>> authenticateEmail(Email email, String password) async {
    try {
      final response = await _auth.signInWithCredential(
        EmailAuthProvider.credential(email: email.value, password: password),
      );
      final user = AuthUser(
        email: email.value,
        contrasena: response.user!.uid,
        foto: response.user!.photoURL,
        nombreCompleto: response.user!.displayName,
      );
      return Success(user);
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión con email y contraseña: $e', e, stackTrace);
      return Failure(ValidationException(e.code));
    }
  }

  //@override
  //Future<Result<User, DomainException>> authenticateMock(
  //  Email email,
  //  String password,
  //  LoginWith type,
  //) async {
  //
  //  // Mock implementation
  //  await Future.delayed(const Duration(milliseconds: 500));
  //
  //  if (email.value == 'test@example.com' && password == 'Password123') {
  //    final user = User.createWithoutPassword(
  //      id: 'mock-user-id-123',
  //      email: email.value,
  //      name: 'Usuario de Prueba',
  //    );
  //
  //    if (user.isFailure) {
  //      return Failure(user.failureValue!);
  //    }
  //
  //    return Success(user.successValue!);
  //  }
  //
  //  return const Failure(ValidationException('Credenciales inválidas'));
  //}
  @override
  Future<Result<AuthUser, DomainException>> register(User user) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(
        email: user.email.value,
        password: user.password!.value,
      );

      final firebaseUser = response.user!;

      final authUser = AuthUser(
        email: firebaseUser.email!,
        contrasena: firebaseUser.uid,
        nombreCompleto: user.name,
        foto:
            user.photoUrl ??
            'https://cdn-icons-png.freepik.com/256/12894/12894535.png?semt=ais_hybrid',
      );

      return Success(authUser);
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.severe('Error al registrar usuario: $e', e, stackTrace);
      return Failure(ValidationException(e.code));
    } catch (e, stackTrace) {
      _logger.severe('Error inesperado al registrar: $e', e, stackTrace);
      return const Failure(ValidationException('Error inesperado al registrar usuario'));
    }
  }

  //@override
  //Future<Result<AuthUser, DomainException>> register(User user) async {
  //  // Mock implementation
  //  await Future.delayed(const Duration(milliseconds: 500));
  //
  //  final createdUser = User.createWithoutPassword(
  //    id: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
  //    email: user.email.value,
  //    name: user.name,
  //    photoUrl: user.photoUrl,
  //  );
  //
  //  if (createdUser.isFailure) {
  //    return Failure(createdUser.failureValue!);
  //  }
  //
  //  return Success(
  //    AuthUser(
  //      email: createdUser.successValue!.email.value,
  //      contrasena: createdUser.successValue!.id.value,
  //      nombreCompleto: createdUser.successValue!.name,
  //      foto: createdUser.successValue!.photoUrl,
  //    ),
  //  );
  //}

  @override
  Future<Result<String, DomainException>> recoverCredential(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Success('success');
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.severe('Error al recuperar credenciales: $e', e, stackTrace);
      return Failure(ValidationException(e.code));
    } catch (e, stackTrace) {
      _logger.severe('Error al recuperar credenciales: $e', e, stackTrace);
      return const Failure(ValidationException('Ocurrió un error inesperado.'));
    }
  }

  @override
  Future<Result<void, DomainException>> signOut() async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 300));
    return const Success(null);
  }

  @override
  Future<Result<User?, DomainException>> getCurrentUser() async {
    // Mock implementation - returns null for now
    await Future.delayed(const Duration(milliseconds: 200));
    return const Success(null);
  }

  @override
  Future<Result<bool, DomainException>> isAuthenticated() async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 100));
    return const Success(false);
  }
}
