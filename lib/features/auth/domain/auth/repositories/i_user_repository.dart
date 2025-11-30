import 'package:goncook/features/auth/data/models/auth_user.dart';

abstract class IUserRepository {
  Future<(bool, String)> signInOrRegister(AuthUser user, {int? type});
  Future<AuthUser> getUser();
  Future<void> register(AuthUser user, {int? type});
  Future<void> logout();
}
