import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_user.g.dart';

@JsonSerializable()
class AuthUser extends Equatable {
  const AuthUser({
    this.id,
    required this.email,
    required this.password,
    this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  final int? id;
  final String email;
  final String password;
  final String? token;

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  AuthUser toModel() {
    return AuthUser(id: id, email: email, password: password, token: token);
  }

  static AuthUser empty() {
    return const AuthUser(id: 0, email: '', password: '', token: '');
  }

  @override
  List<Object?> get props => [id, email, password, token];
}
