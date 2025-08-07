import 'package:recetasperuanas/core/auth/models/auth_user.dart';

abstract class IUserRepository {
  Future<(bool, String)> signInOrRegister(AuthUser user, {int? type});
  Future<AuthUser> getUser();
  Future<void> register(AuthUser user, {int? type});
  Future<void> logout();
}
