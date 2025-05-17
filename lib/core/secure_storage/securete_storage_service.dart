import 'package:encrypt/encrypt.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:logging/logging.dart';

final secretKey = dotenv.env['SECRET_KEY']!;

class SecurityStorageService implements ISecureStorageService {
  factory SecurityStorageService() {
    return _instance;
  }

  SecurityStorageService._internal();
  final storage = const FlutterSecureStorage();
  static final SecurityStorageService _instance =
      SecurityStorageService._internal();

  final _logger = Logger('SecurityStorageService');
  final key = Key.fromUtf8(secretKey);
  final iv = IV.fromLength(16);

  String encrypt(String plaintext) {
    try {
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(AES(key));
      final encrypted = encrypter.encrypt(plaintext, iv: iv);
      return '${iv.base64}:${encrypted.base64}';
    } catch (e, stackTrace) {
      _logger.severe('Error al encriptar: ', e, stackTrace);
      return '$e';
    }
  }

  String decrypt(String encryptedText) {
    try {
      final parts = encryptedText.split(':');
      final iv = IV.fromBase64(parts[0]);
      final encrypted = parts[1];
      final encrypter = Encrypter(AES(key));
      return encrypter.decrypt64(encrypted, iv: iv);
    } catch (e, stackTrace) {
      _logger.severe('Error al desencriptar: ', e, stackTrace);
      return '$e';
    }
  }

  @override
  Future<void> saveCredentials(AuthUser credentials) async {
    if (credentials.id != null) {
      await storage.write(key: 'id', value: credentials.id.toString());
    }

    await storage.write(key: 'email', value: credentials.email);

    // Encriptar y guardar contraseña
    final encryptedPassword = encrypt(credentials.password);
    await storage.write(key: 'password', value: encryptedPassword);

    // Encriptar y guardar token
    final encryptedToken = encrypt(credentials.token!);
    await storage.write(key: 'token', value: encryptedToken);
  }

  @override
  Future<AuthUser?> loadCredentials() async {
    final id = await storage.read(key: 'id');
    final email = await storage.read(key: 'email');
    final encryptedPassword = await storage.read(key: 'password');
    final encryptedToken = await storage.read(key: 'token');

    // Desencriptar la contraseña
    final String? password =
        encryptedPassword != null ? decrypt(encryptedPassword) : null;

    // Desencriptar el token
    final String? token =
        encryptedToken != null ? decrypt(encryptedToken) : null;

    if (encryptedToken == null) {
      return AuthUser.empty();
    }

    return AuthUser(
      id: int.tryParse(id!),
      email: email!,
      password: password!,
      token: token,
    );
  }

  @override
  Future<void> deleteCredentials() async {
    // await storage.delete(key: 'id');
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
    await storage.delete(key: 'token');
  }
}

abstract interface class ISecureStorageService {
  Future<void> saveCredentials(AuthUser credentials);
  Future<AuthUser?> loadCredentials();
  Future<void> deleteCredentials();
}
