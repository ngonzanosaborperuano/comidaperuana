import 'package:goncook/features/auth/data/models/auth_model.dart';

abstract class IUserRepository {
  Future<(bool, String)> signInOrRegister(AuthModel user, {int? type});
  Future<AuthModel> getUser();
  Future<bool> register(AuthModel user, {int? type});
  Future<bool> logout();
}
